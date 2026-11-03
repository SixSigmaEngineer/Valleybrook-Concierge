@echo off
setlocal EnableExtensions
title Valleybrook Concierge - Sync with GitHub
cd /d "%~dp0"

set "REPO_URL=https://github.com/SixSigmaEngineer/Valleybrook-Concierge.git"
set "BRANCH=main"

echo ================================================
echo   Valleybrook Concierge  -^>  GitHub
echo   %REPO_URL%
echo ================================================
echo.

REM ---------- 1. Make sure Git is installed ----------
where git >nul 2>&1
if errorlevel 1 (
  echo Git is not installed on this computer.
  echo Opening the download page. Install it with the default options,
  echo then double-click this file again.
  start "" "https://git-scm.com/download/win"
  pause
  exit /b 1
)

REM ---------- 2. Organize photos ----------
echo Organizing photos...
if not exist "photos" mkdir "photos"
if not exist "photos\floor-plan" mkdir "photos\floor-plan"
if not exist "photos\signs" mkdir "photos\signs"
if not exist "photos\equipment" mkdir "photos\equipment"
if not exist "photos\equipment\.gitkeep" type nul > "photos\equipment\.gitkeep"

if exist "Map Valleybrook.jpg"  move /y "Map Valleybrook.jpg"  "photos\floor-plan\floor-plan-v2-lower-level-1.jpg" >nul
if exist "IMG_1088.jpeg"        move /y "IMG_1088.jpeg"        "photos\floor-plan\floor-plan-v2-lower-level-2.jpeg" >nul
if exist "IMG_1089.jpeg"        move /y "IMG_1089.jpeg"        "photos\floor-plan\floor-plan-v2-lower-level-3.jpeg" >nul
if exist "evacuation plan.jpg"  move /y "evacuation plan.jpg"  "photos\signs\emergency-procedures-sign-1.jpg" >nul
if exist "IMG_1087.jpeg"        move /y "IMG_1087.jpeg"        "photos\signs\emergency-procedures-sign-2.jpeg" >nul
if exist "IMG_1086.jpeg"        move /y "IMG_1086.jpeg"        "photos\signs\elevator-maintenance-help-sign.jpeg" >nul

REM Any other new photos dropped next to index.html go to photos\ (sort them later)
for %%E in (jpg jpeg png heic gif webp) do (
  for %%F in (*.%%E) do move /y "%%F" "photos\" >nul
)
echo   done.
echo.

REM ---------- 3. Set up the local repository (first run only) ----------
set "FIRSTRUN="
if not exist ".git" (
  echo First run: setting up Git in this folder...
  set "FIRSTRUN=1"
  git init >nul
  git checkout -b %BRANCH% >nul 2>&1
)
git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin "%REPO_URL%"
) else (
  git remote set-url origin "%REPO_URL%"
)

REM First run in a folder that came from a zip or a copy: link it to the
REM existing GitHub history without touching the files here, so the files
REM in this folder become new changes on top of what's already on GitHub.
if defined FIRSTRUN (
  git ls-remote --exit-code --heads origin %BRANCH% >nul 2>&1
  if not errorlevel 1 (
    echo Linking this folder to the project on GitHub...
    git fetch origin %BRANCH%
    if errorlevel 1 (
      echo *** Couldn't reach GitHub. Check your internet connection and try again. ***
      rmdir /s /q ".git"
      pause
      exit /b 1
    )
    git reset origin/%BRANCH% >nul
    git branch --set-upstream-to=origin/%BRANCH% %BRANCH% >nul 2>&1
  )
)

REM ---------- 4. Make sure Git knows who you are ----------
for /f "delims=" %%N in ('git config user.name 2^>nul') do set "GITNAME=%%N"
if not defined GITNAME (
  set /p "GITNAME=Your name (shown on your changes): "
  call git config --global user.name "%%GITNAME%%"
)
for /f "delims=" %%M in ('git config user.email 2^>nul') do set "GITMAIL=%%M"
if not defined GITMAIL (
  set /p "GITMAIL=Your GitHub email: "
  call git config --global user.email "%%GITMAIL%%"
)

REM ---------- 5. Commit your changes ----------
git add -A
git diff --cached --quiet
if errorlevel 1 (
  echo.
  set "MSG="
  set /p "MSG=Describe your changes (or press Enter for a default): "
  if not defined MSG set "MSG=Update from %COMPUTERNAME% on %DATE% %TIME%"
  call git commit -m "%%MSG%%" >nul
  echo   Changes saved locally.
) else (
  echo No new local changes to upload.
)

REM ---------- 6. Get your team's latest changes ----------
echo.
echo Getting your team's latest changes from GitHub...
git ls-remote --exit-code --heads origin %BRANCH% >nul 2>&1
if errorlevel 1 goto push
git pull --rebase origin %BRANCH%
if errorlevel 1 (
  echo.
  echo *** Your changes conflict with a teammate's changes to the same file. ***
  echo Ask a teammate for help, or run:  git rebase --abort   to undo this sync.
  pause
  exit /b 1
)

REM ---------- 7. Upload ----------
:push
echo.
echo Uploading to GitHub...
echo (The first time, a browser window may open so you can sign in to GitHub.)
git push -u origin %BRANCH%
if errorlevel 1 (
  echo.
  echo *** Upload failed. Check that you're signed in to GitHub and that the repo owner
  echo     has added you as a collaborator on the repository. ***
  pause
  exit /b 1
)

echo.
echo ================================================
echo   All synced!  https://github.com/SixSigmaEngineer/Valleybrook-Concierge
echo ================================================
pause
