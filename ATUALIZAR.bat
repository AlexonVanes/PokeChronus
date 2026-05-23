@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ==========================================
echo ATUALIZAR PROJETO
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

for /f "delims=" %%A in ('git status --porcelain') do (
  echo Existem alteraÃ§Ãµes locais. Execute ENVIAR.bat antes de atualizar.
  pause
  exit /b 1
)

echo Baixando informacoes novas...
git fetch
if errorlevel 1 (
  echo ERRO: Nao foi possivel buscar atualizacoes. Verifique internet, login ou permissao.
  pause
  exit /b 1
)

echo Atualizando arquivos...
git pull --ff-only
if errorlevel 1 (
  echo ERRO: Nao foi possivel atualizar automaticamente.
  echo Chame o Alexon.
  pause
  exit /b 1
)

echo Baixando arquivos grandes do Git LFS...
git lfs pull
if errorlevel 1 (
  echo ERRO: Nao foi possivel baixar os arquivos grandes.
  echo Verifique internet, login ou permissao.
  pause
  exit /b 1
)

echo Validando pacote Release recebido...
call VERIFICAR_AMBIENTE.bat /nopause
if errorlevel 1 (
  echo ERRO: A atualizacao terminou, mas o pacote recebido esta incompleto.
  echo Chame o Alexon antes de iniciar o jogo.
  pause
  exit /b 1
)

echo.
echo OK: Projeto atualizado com sucesso.
pause
exit /b 0
