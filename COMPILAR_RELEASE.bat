@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

set "SAIDA=1"
set "BUILD_DRIVE=P:"
set "MAPPED="
set "VCPKG=%VCPKG_ROOT%\vcpkg.exe"
if not exist "%VCPKG%" set "VCPKG=C:\vcpkg\vcpkg.exe"

echo ==========================================
echo COMPILAR PACOTE RELEASE
echo ==========================================
echo.

if not exist "%VCPKG%" (
  echo ERRO: vcpkg.exe nao encontrado.
  echo Instale o vcpkg em C:\vcpkg ou defina VCPKG_ROOT.
  goto :fim
)

set "VSROOT=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools"
set "MSBUILD=%VSROOT%\MSBuild\Current\Bin\amd64\MSBuild.exe"
if not exist "%MSBUILD%" (
  set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
  if exist "%VSWHERE%" (
    for /f "usebackq delims=" %%I in (`"%VSWHERE%" -latest -version "[17.0,18.0)" -products * -requires Microsoft.Component.MSBuild -property installationPath`) do set "VSROOT=%%I"
    set "MSBUILD=!VSROOT!\MSBuild\Current\Bin\amd64\MSBuild.exe"
  )
)
if not exist "%MSBUILD%" (
  echo ERRO: Visual Studio 2022 Build Tools com MSBuild/v143 nao encontrado.
  echo Instale a carga de trabalho Desktop development with C++.
  goto :fim
)

subst | findstr /b /i /c:"%BUILD_DRIVE%\:" >nul
if not errorlevel 1 (
  echo ERRO: A unidade %BUILD_DRIVE% ja esta em uso.
  echo Libere essa unidade temporaria e tente novamente.
  goto :fim
)

subst %BUILD_DRIVE% "%CD%"
if errorlevel 1 (
  echo ERRO: Nao foi possivel mapear o projeto em %BUILD_DRIVE%.
  goto :fim
)
set "MAPPED=1"

echo Restaurando dependencias Release do servidor...
"%VCPKG%" install --triplet=x64-windows --overlay-triplets="%BUILD_DRIVE%\tools\vcpkg\triplets" --x-manifest-root="%BUILD_DRIVE%\server" --x-install-root="%BUILD_DRIVE%\server\vcpkg_installed" --clean-after-build
if errorlevel 1 goto :falha

echo Restaurando dependencias Release do cliente...
"%VCPKG%" install --triplet=x64-windows-static --overlay-triplets="%BUILD_DRIVE%\tools\vcpkg\triplets" --x-manifest-root="%BUILD_DRIVE%\client\sources" --x-install-root="%BUILD_DRIVE%\client\sources\vcpkg_static" --clean-after-build
if errorlevel 1 goto :falha

echo Compilando servidor Release x64...
"%MSBUILD%" "%BUILD_DRIVE%\server\vc17\theforgottenserver.sln" /t:Rebuild /m /nologo /v:minimal /p:Configuration=Release /p:Platform=x64 /p:VcpkgEnableManifest=false
if errorlevel 1 goto :falha

echo Compilando cliente OpenGL Release x64...
"%MSBUILD%" "%BUILD_DRIVE%\client\sources\vc17\otclient.sln" /t:Rebuild /m /nologo /v:minimal /p:Configuration=OpenGL /p:Platform=x64 /p:VcpkgEnableManifest=false /p:EnableUnitySupport=false
if errorlevel 1 goto :falha

echo Copiando DLLs Release produzidas pelo vcpkg para o servidor...
copy /Y "%BUILD_DRIVE%\server\vcpkg_installed\x64-windows\bin\*.dll" "%BUILD_DRIVE%\server\" >nul
if errorlevel 1 goto :falha

set "CRT="
for /d %%I in ("%VSROOT%\VC\Redist\MSVC\*") do if exist "%%~fI\x64\Microsoft.VC143.CRT" set "CRT=%%~fI\x64\Microsoft.VC143.CRT"
if not defined CRT (
  echo ERRO: Microsoft.VC143.CRT Release nao encontrado no Visual Studio.
  goto :falha
)

echo Copiando runtime Microsoft VC143 Release...
copy /Y "%CRT%\*.dll" "%BUILD_DRIVE%\server\" >nul
if errorlevel 1 goto :falha

set "SAIDA=0"
goto :fim

:falha
echo.
echo ERRO: A compilacao Release nao foi concluida.

:fim
if defined MAPPED subst %BUILD_DRIVE% /D >nul
if "%SAIDA%"=="0" (
  echo.
  call VERIFICAR_AMBIENTE.bat /nopause
  if errorlevel 1 set "SAIDA=1"
)
echo.
if "%SAIDA%"=="0" (
  echo OK: Pacote Release pronto para revisar e enviar pelo Git LFS.
) else (
  echo ERRO: Corrija os itens acima antes de enviar o pacote.
)
pause
exit /b %SAIDA%
