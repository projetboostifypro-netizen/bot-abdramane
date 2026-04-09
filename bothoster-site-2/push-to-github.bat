@echo off
chcp 65001 > nul
echo.
echo ╔══════════════════════════════════════════════════╗
echo ║   BotHoster — Push automatique vers GitHub       ║
echo ╚══════════════════════════════════════════════════╝
echo.

set /p GITHUB_TOKEN="Token GitHub (github.com/settings/tokens) : "
set /p REPO_NAME="Nom du depot (ex: bothoster-site) : "
set /p PRIVATE_INPUT="Depot prive ? (oui/non) [non] : "

set PRIVATE_BOOL=false
if /i "%PRIVATE_INPUT%"=="oui" set PRIVATE_BOOL=true
if /i "%PRIVATE_INPUT%"=="o" set PRIVATE_BOOL=true

echo.
echo Verification du token et creation du depot...

for /f "tokens=2 delims=:, " %%a in ('curl -s -H "Authorization: token %GITHUB_TOKEN%" https://api.github.com/user ^| findstr "login"') do (
  set GITHUB_USER=%%~a
  goto :found_user
)
:found_user
set GITHUB_USER=%GITHUB_USER:"=%

echo Connecte en tant que : %GITHUB_USER%

curl -s -X POST -H "Authorization: token %GITHUB_TOKEN%" -H "Content-Type: application/json" -d "{\"name\":\"%REPO_NAME%\",\"private\":%PRIVATE_BOOL%,\"description\":\"BotHoster - Plateforme d'hébergement de bots\"}" https://api.github.com/user/repos > nul

echo Initialisation de git...
git init
git add .
git commit -m "Initial commit — BotHoster site v1.0"
git branch -M main
git remote remove origin 2>nul
git remote add origin https://%GITHUB_USER%:%GITHUB_TOKEN%@github.com/%GITHUB_USER%/%REPO_NAME%.git
git push -u origin main

echo.
echo ✅ Code pousse sur GitHub !
echo Depot : https://github.com/%GITHUB_USER%/%REPO_NAME%
echo.
echo Prochaine etape : https://vercel.com/new
echo Importez le depot %REPO_NAME% et deployez !
pause
