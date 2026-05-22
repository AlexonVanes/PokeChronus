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
