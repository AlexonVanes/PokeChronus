@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

set "SERVER_DIR=server"
set "SERVER_EXE=- theforgottenserver-x64.exe"

if not exist "%SERVER_DIR%\%SERVER_EXE%" (
  echo Servidor incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %SERVER_DIR%\%SERVER_EXE%
  pause
  exit /b 1
)

findstr /m /i /c:"VCRUNTIME140D.dll" /c:"MSVCP140D.dll" /c:"ucrtbased.dll" "%SERVER_DIR%\*.exe" "%SERVER_DIR%\*.dll" >nul 2>nul
if not errorlevel 1 (
  echo ERRO: A distribuicao do servidor contem binario compilado em modo Debug.
  echo.
  echo Um executavel ou DLL carregada exige runtimes internos do Visual Studio:
  echo VCRUNTIME140D.dll, MSVCP140D.dll e ucrtbased.dll.
  echo Esses arquivos Debug nao devem ser distribuidos para jogar ou hospedar.
  echo.
  echo Baixe novamente os arquivos do Git com Git LFS ou substitua
  echo o pacote server por uma compilacao Release x64 completa.
  pause
  exit /b 1
)

if not exist "%SERVER_DIR%\data\" (
  echo Servidor incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %SERVER_DIR%\data\
  pause
  exit /b 1
)

if not exist "%SERVER_DIR%\config.lua" (
  echo Servidor incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %SERVER_DIR%\config.lua
  pause
  exit /b 1
)

if not exist "%SERVER_DIR%\data\world\map2.otbm" (
  echo Servidor incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %SERVER_DIR%\data\world\map2.otbm
  pause
  exit /b 1
)

if not exist "%SERVER_DIR%\data\items\items.otb" (
  echo Servidor incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %SERVER_DIR%\data\items\items.otb
  pause
  exit /b 1
)

pushd "%SERVER_DIR%"
echo Abrindo servidor...
start "" "%SERVER_EXE%"
popd
exit /b 0
