@echo off
setlocal EnableDelayedExpansion
title Discord AI Bot - Launcher
color 0A

echo ============================================================
echo   Discord AI Bot - Windows Launcher
echo ============================================================
echo.

REM ---------------------------------------------------------------
REM 1. Check Python is installed
REM ---------------------------------------------------------------
echo [1/6] Checking for Python...
where python >nul 2>nul
if errorlevel 1 (
    echo.
    echo [ERROR] Python was not found on your PATH.
    echo Please install Python 3.12 or newer from https://www.python.org/downloads/
    echo IMPORTANT: During installation, check "Add python.exe to PATH".
    echo.
    pause
    exit /b 1
)
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set PYVER=%%v
echo       Found Python %PYVER%
echo.

REM ---------------------------------------------------------------
REM 2. Create virtual environment if missing
REM ---------------------------------------------------------------
echo [2/6] Checking for virtual environment...
if not exist ".venv\Scripts\python.exe" (
    echo       No virtual environment found. Creating one now...
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create the virtual environment.
        pause
        exit /b 1
    )
    echo       Virtual environment created at .venv\
) else (
    echo       Virtual environment already exists.
)
echo.

REM ---------------------------------------------------------------
REM 3. Activate virtual environment
REM ---------------------------------------------------------------
echo [3/6] Activating virtual environment...
call ".venv\Scripts\activate.bat"
if errorlevel 1 (
    echo [ERROR] Failed to activate the virtual environment.
    pause
    exit /b 1
)
echo       Activated.
echo.

REM ---------------------------------------------------------------
REM 4. Install dependencies
REM ---------------------------------------------------------------
echo [4/6] Installing/updating dependencies (this may take a minute the first time)...
python -m pip install --upgrade pip --quiet
pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies. Check your internet connection and try again.
    pause
    exit /b 1
)
echo       Dependencies are up to date.
echo.

REM ---------------------------------------------------------------
REM 5. Verify the .env file
REM ---------------------------------------------------------------
echo [5/6] Checking configuration...
if not exist ".env" (
    echo       No .env file found. Creating one from .env.example...
    copy ".env.example" ".env" >nul
    echo.
    echo [ACTION REQUIRED] A new .env file was created.
    echo Please open .env in VS Code and fill in:
    echo   - DISCORD_BOT_TOKEN
    echo   - OPENAI_API_KEY
    echo Then run this script again.
    echo.
    pause
    exit /b 0
)

findstr /C:"DISCORD_BOT_TOKEN=" ".env" | findstr /V "DISCORD_BOT_TOKEN=$" >nul
set TOKEN_OK=%errorlevel%
findstr /C:"OPENAI_API_KEY=" ".env" | findstr /V "OPENAI_API_KEY=$" >nul
set KEY_OK=%errorlevel%

if not "%TOKEN_OK%"=="0" (
    echo.
    echo [ACTION REQUIRED] DISCORD_BOT_TOKEN is missing from your .env file.
    echo Open .env in VS Code and paste in your bot token, then run this script again.
    echo.
    pause
    exit /b 0
)
if not "%KEY_OK%"=="0" (
    echo.
    echo [ACTION REQUIRED] OPENAI_API_KEY is missing from your .env file.
    echo Open .env in VS Code and paste in your OpenAI API key, then run this script again.
    echo.
    pause
    exit /b 0
)
echo       Configuration looks good.
echo.

REM ---------------------------------------------------------------
REM 6. Start the application
REM ---------------------------------------------------------------
echo [6/6] Starting Discord AI Bot...
echo ============================================================
echo.
python -m app.main

echo.
echo ============================================================
echo The application has stopped.
if errorlevel 1 (
    echo It looks like it exited with an error - see the messages above.
)
echo ============================================================
pause
