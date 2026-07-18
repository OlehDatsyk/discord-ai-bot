#!/usr/bin/env bash
# ============================================================
# Discord AI Bot - macOS Launcher
# Double-click this file in Finder to run the bot.
# ============================================================
set -uo pipefail
cd "$(dirname "$0")"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "============================================================"
echo "  Discord AI Bot - macOS Launcher"
echo "============================================================"
echo

fail() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo
    read -n 1 -s -r -p "Press any key to close this window..."
    exit 1
}

# ---------------------------------------------------------------
# 1. Check Python is installed
# ---------------------------------------------------------------
echo "[1/6] Checking for Python..."
PYTHON_BIN=""
for candidate in python3.12 python3.13 python3; do
    if command -v "$candidate" >/dev/null 2>&1; then
        PYTHON_BIN="$candidate"
        break
    fi
done

if [ -z "$PYTHON_BIN" ]; then
    fail "Python was not found. Install Python 3.12+ from https://www.python.org/downloads/ then run this script again."
fi
echo -e "      Found $($PYTHON_BIN --version)"
echo

# ---------------------------------------------------------------
# 2. Create virtual environment if missing
# ---------------------------------------------------------------
echo "[2/6] Checking for virtual environment..."
if [ ! -f ".venv/bin/python" ]; then
    echo "      No virtual environment found. Creating one now..."
    "$PYTHON_BIN" -m venv .venv || fail "Failed to create the virtual environment."
    echo "      Virtual environment created at .venv/"
else
    echo "      Virtual environment already exists."
fi
echo

# ---------------------------------------------------------------
# 3. Activate virtual environment
# ---------------------------------------------------------------
echo "[3/6] Activating virtual environment..."
# shellcheck disable=SC1091
source ".venv/bin/activate" || fail "Failed to activate the virtual environment."
echo "      Activated."
echo

# ---------------------------------------------------------------
# 4. Install dependencies
# ---------------------------------------------------------------
echo "[4/6] Installing/updating dependencies (this may take a minute the first time)..."
python -m pip install --upgrade pip --quiet
pip install -r requirements.txt --quiet || fail "Failed to install dependencies. Check your internet connection and try again."
echo "      Dependencies are up to date."
echo

# ---------------------------------------------------------------
# 5. Verify the .env file
# ---------------------------------------------------------------
echo "[5/6] Checking configuration..."
if [ ! -f ".env" ]; then
    echo "      No .env file found. Creating one from .env.example..."
    cp ".env.example" ".env"
    echo
    echo -e "${YELLOW}[ACTION REQUIRED]${NC} A new .env file was created."
    echo "Please open .env in VS Code and fill in:"
    echo "  - DISCORD_BOT_TOKEN"
    echo "  - OPENAI_API_KEY"
    echo "Then run this script again."
    echo
    read -n 1 -s -r -p "Press any key to close this window..."
    exit 0
fi

if ! grep -q "^DISCORD_BOT_TOKEN=.\+" ".env"; then
    echo
    echo -e "${YELLOW}[ACTION REQUIRED]${NC} DISCORD_BOT_TOKEN is missing from your .env file."
    echo "Open .env in VS Code and paste in your bot token, then run this script again."
    echo
    read -n 1 -s -r -p "Press any key to close this window..."
    exit 0
fi

if ! grep -q "^OPENAI_API_KEY=.\+" ".env"; then
    echo
    echo -e "${YELLOW}[ACTION REQUIRED]${NC} OPENAI_API_KEY is missing from your .env file."
    echo "Open .env in VS Code and paste in your OpenAI API key, then run this script again."
    echo
    read -n 1 -s -r -p "Press any key to close this window..."
    exit 0
fi
echo "      Configuration looks good."
echo

# ---------------------------------------------------------------
# 6. Start the application
# ---------------------------------------------------------------
echo "[6/6] Starting Discord AI Bot..."
echo "============================================================"
echo
python -m app.main
EXIT_CODE=$?

echo
echo "============================================================"
echo "The application has stopped."
if [ $EXIT_CODE -ne 0 ]; then
    echo -e "${RED}It looks like it exited with an error (exit code $EXIT_CODE) - see the messages above.${NC}"
fi
echo "============================================================"
read -n 1 -s -r -p "Press any key to close this window..."
