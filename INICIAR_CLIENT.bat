@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

set "CLIENT_DIR=client"
set "CLIENT_EXE=-=otclient_gl.exe"

if not exist "%CLIENT_DIR%\%CLIENT_EXE%" (
  echo Client incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %CLIENT_DIR%\%CLIENT_EXE%
  pause
  exit /b 1
)

if not exist "%CLIENT_DIR%\data\" (
  echo Client incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %CLIENT_DIR%\data\
  pause
  exit /b 1
)

if not exist "%CLIENT_DIR%\modules\" (
  echo Client incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %CLIENT_DIR%\modules\
  pause
  exit /b 1
)

if not exist "%CLIENT_DIR%\data\things\1098\Tibia.spr" (
  echo Client incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %CLIENT_DIR%\data\things\1098\Tibia.spr
  pause
  exit /b 1
)

if not exist "%CLIENT_DIR%\data\things\1098\Tibia.dat" (
  echo Client incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %CLIENT_DIR%\data\things\1098\Tibia.dat
  pause
  exit /b 1
)

if not exist "%CLIENT_DIR%\data\things\1098\Tibia.cwm" (
  echo Client incompleto. Execute ATUALIZAR.bat ou chame o Alexon.
  echo Faltando: %CLIENT_DIR%\data\things\1098\Tibia.cwm
  pause
  exit /b 1
)

pushd "%CLIENT_DIR%"
echo Abrindo client...
start "" "%CLIENT_EXE%"
popd
exit /b 0
