@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ==========================================
echo ENVIAR ALTERACOES
echo ==========================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo ERRO: Git nao esta instalado.
  echo Instale o Git for Windows e tente novamente.
  pause
  exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo ERRO: Esta pasta ainda nao e um repositorio Git valido.
  echo Clone o repositorio novamente ou chame o Alexon.
  pause
  exit /b 1
)

git lfs version >nul 2>nul
if errorlevel 1 (
  echo ERRO: Git LFS nao esta instalado.
  echo Instale o Git LFS e tente novamente.
  pause
  exit /b 1
)

git lfs install
if errorlevel 1 (
  echo ERRO: Nao foi possivel preparar o Git LFS.
  pause
  exit /b 1
)

echo Status atual:
git status --short
echo.

set "HAS_CHANGES="
for /f "delims=" %%A in ('git status --porcelain') do set "HAS_CHANGES=1"
if not defined HAS_CHANGES (
  echo Nenhuma alteraÃ§Ã£o encontrada para enviar.
  pause
  exit /b 0
)

echo Preparando alteracoes...
git add -A
if errorlevel 1 (
  echo ERRO: Nao foi possivel preparar os arquivos.
  pause
  exit /b 1
)

for /f "tokens=1-4 delims=/ " %%a in ("%date%") do set "DATA=%%a-%%b-%%c"
set "HORA=%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "HORA=%HORA: =0%"
set "MSG=Atualizacao automatica %DATA% %HORA% por %USERNAME%"

echo Criando commit...
git commit -m "%MSG%"
if errorlevel 1 (
  echo ERRO: Nao foi possivel criar o commit.
  pause
  exit /b 1
)

echo Juntando alteracoes novas antes de enviar...
git pull --rebase
if errorlevel 1 (
  echo Houve conflito ao juntar alteraÃ§Ãµes. NÃ£o feche esta janela se nÃ£o souber resolver. Chame o Alexon.
  pause
  exit /b 1
)

echo Enviando para o repositorio...
git push
if errorlevel 1 (
  echo ERRO: Nao foi possivel enviar.
  echo Verifique login, internet ou permissao. Se continuar, chame o Alexon.
  pause
  exit /b 1
)

echo.
echo OK: Alteracoes enviadas com sucesso.
pause
exit /b 0
