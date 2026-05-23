@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
set "NO_PAUSE="
if /i "%~1"=="/nopause" set "NO_PAUSE=1"

echo ==========================================
echo VERIFICAR AMBIENTE
echo ==========================================
echo.

set "ERROS=0"
set "AVISOS=0"

where git >nul 2>nul
if errorlevel 1 (
  echo ERRO  - Git instalado
  set /a ERROS+=1
) else (
  echo OK    - Git instalado
)

git lfs version >nul 2>nul
if errorlevel 1 (
  echo ERRO  - Git LFS instalado
  set /a ERROS+=1
) else (
  echo OK    - Git LFS instalado
)

git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo ERRO  - Repositorio Git valido
  set /a ERROS+=1
) else (
  echo OK    - Repositorio Git valido
)

if exist "client" (echo OK    - Pasta do client) else (echo ERRO  - Pasta do client & set /a ERROS+=1)
if exist "client\-=otclient_gl.exe" (echo OK    - Executavel principal do client) else (echo ERRO  - Executavel principal do client & set /a ERROS+=1)
if exist "client\data" (echo OK    - Data do client) else (echo ERRO  - Data do client & set /a ERROS+=1)
if exist "client\modules" (echo OK    - Modules do client) else (echo ERRO  - Modules do client & set /a ERROS+=1)
if exist "client\data\things\1098\Tibia.spr" (echo OK    - Tibia.spr) else (echo ERRO  - Tibia.spr & set /a ERROS+=1)
if exist "client\data\things\1098\Tibia.dat" (echo OK    - Tibia.dat) else (echo ERRO  - Tibia.dat & set /a ERROS+=1)
if exist "client\data\things\1098\Tibia.cwm" (echo OK    - Tibia.cwm) else (echo ERRO  - Tibia.cwm & set /a ERROS+=1)
if exist "client\libGLESv2.dll" (echo OK    - DLL principal do client: libGLESv2.dll) else (echo ERRO  - DLL principal do client: libGLESv2.dll & set /a ERROS+=1)
if exist "client\OpenAL32.dll" (echo OK    - DLL principal do client: OpenAL32.dll) else (echo ERRO  - DLL principal do client: OpenAL32.dll & set /a ERROS+=1)
if exist "client\lua51.dll" (echo OK    - DLL principal do client: lua51.dll) else (echo ERRO  - DLL principal do client: lua51.dll & set /a ERROS+=1)
findstr /m /i /c:"VCRUNTIME140D.dll" /c:"MSVCP140D.dll" /c:"ucrtbased.dll" "client\*.exe" "client\*.dll" >nul 2>nul
if not errorlevel 1 (
  echo ERRO  - Client contem EXE ou DLL Debug e exige runtimes nao redistribuiveis
  set /a ERROS+=1
) else (
  echo OK    - Binarios do client nao referenciam runtime Debug
)

if exist "server" (echo OK    - Pasta do servidor) else (echo ERRO  - Pasta do servidor & set /a ERROS+=1)
if exist "server\- theforgottenserver-x64.exe" (
  echo OK    - Executavel principal do servidor
  findstr /m /i /c:"VCRUNTIME140D.dll" /c:"MSVCP140D.dll" /c:"ucrtbased.dll" "server\*.exe" "server\*.dll" >nul 2>nul
  if not errorlevel 1 (
    echo ERRO  - Servidor contem EXE ou DLL Debug e exige runtimes nao redistribuiveis
    echo         Use uma compilacao Release x64 completa e atualize os binarios pelo Git LFS.
    set /a ERROS+=1
  ) else (
    echo OK    - Binarios do servidor nao referenciam runtime Debug
  )
) else (echo ERRO  - Executavel principal do servidor & set /a ERROS+=1)
if exist "server\data" (echo OK    - Data do servidor) else (echo ERRO  - Data do servidor & set /a ERROS+=1)
if exist "server\config.lua" (echo OK    - Config do servidor) else (echo ERRO  - Config do servidor & set /a ERROS+=1)
if exist "server\data\world\map2.otbm" (echo OK    - Mapa do servidor) else (echo ERRO  - Mapa do servidor & set /a ERROS+=1)
if exist "server\data\items\items.otb" (echo OK    - Items OTB) else (echo ERRO  - Items OTB & set /a ERROS+=1)
if exist "server\libcrypto-3-x64.dll" (echo OK    - DLL principal do servidor: libcrypto) else (echo ERRO  - DLL principal do servidor: libcrypto & set /a ERROS+=1)
if exist "server\libssl-3-x64.dll" (echo OK    - DLL principal do servidor: libssl) else (echo ERRO  - DLL principal do servidor: libssl & set /a ERROS+=1)
if exist "server\lua.dll" (echo OK    - DLL principal do servidor: lua) else (echo ERRO  - DLL principal do servidor: lua & set /a ERROS+=1)
if exist "server\libmariadb.dll" (echo OK    - DLL principal do servidor: MariaDB) else (echo ERRO  - DLL principal do servidor: MariaDB & set /a ERROS+=1)
if exist "server\msvcp140.dll" (echo OK    - Runtime Release do servidor: MSVCP140.dll) else (echo ERRO  - Runtime Release do servidor: MSVCP140.dll & set /a ERROS+=1)
if exist "server\vcruntime140.dll" (echo OK    - Runtime Release do servidor: vcruntime140.dll) else (echo ERRO  - Runtime Release do servidor: vcruntime140.dll & set /a ERROS+=1)
if exist "server\vcruntime140_1.dll" (echo OK    - Runtime Release do servidor: vcruntime140_1.dll) else (echo ERRO  - Runtime Release do servidor: vcruntime140_1.dll & set /a ERROS+=1)

if exist "server\config.lua" (
  findstr /i "mysqlPass password token secret senha" "server\config.lua" >nul 2>nul
  if errorlevel 1 (
    echo OK    - Nenhuma credencial obvia encontrada em server\config.lua
  ) else (
    echo AVISO - server\config.lua contem campos de senha/credencial. Revisar manualmente.
    set /a AVISOS+=1
  )
)

echo.
echo Resultado:
echo ERROS: %ERROS%
echo AVISOS: %AVISOS%
if "%ERROS%"=="0" (
  echo OK: Ambiente parece completo.
  if not defined NO_PAUSE pause
  exit /b 0
) else (
  echo ERRO: Ambiente incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  if not defined NO_PAUSE pause
  exit /b 1
)
