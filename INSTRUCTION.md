# INSTRUCTION.md - Complete Beginner's Guide to Discord AI Bot

This guide assumes you have **never** used Python, Visual Studio Code, Git,
FastAPI, the OpenAI API, n8n, Zapier, or Make before. Follow every step in
order and you will end up with a working AI-powered Discord bot.

> 💡 Wherever you see `[SCREENSHOT: ...]`, that's a placeholder - the real
> interface may look slightly different depending on your OS version, but
> the buttons/labels described will be there.

---

## Table of Contents

1. [Installing Python](#1-installing-python)
2. [Installing Visual Studio Code](#2-installing-visual-studio-code)
3. [Installing Git](#3-installing-git)
4. [Installing required VS Code extensions](#4-installing-required-vs-code-extensions)
5. [Opening the project](#5-opening-the-project)
6. [Creating a virtual environment](#6-creating-a-virtual-environment)
7. [Activating the virtual environment](#7-activating-the-virtual-environment)
8. [Installing dependencies](#8-installing-dependencies)
9. [Creating the .env file](#9-creating-the-env-file)
10. [Obtaining OpenAI API keys](#10-obtaining-openai-api-keys)
11. [Setting up Google Cloud (if required)](#11-setting-up-google-cloud-if-required)
12. [Setting up a Telegram Bot (if applicable)](#12-setting-up-a-telegram-bot-if-applicable)
13. [Setting up a Discord Bot](#13-setting-up-a-discord-bot)
14. [Configuring OAuth credentials (if applicable)](#14-configuring-oauth-credentials-if-applicable)
15. [Running the application](#15-running-the-application)
16. [Running the automation workflows](#16-running-the-automation-workflows)
17. [Importing the n8n workflow](#17-importing-the-n8n-workflow)
18. [Setting up the Zapier Zap](#18-setting-up-the-zapier-zap)
19. [Importing the Make scenario](#19-importing-the-make-scenario)
20. [Testing every feature](#20-testing-every-feature)
21. [Common errors](#21-common-errors)
22. [Troubleshooting](#22-troubleshooting)
23. [Project architecture](#23-project-architecture)
24. [Folder structure](#24-folder-structure)
25. [FAQ](#25-faq)
26. [Security best practices](#26-security-best-practices)
27. [Next learning steps](#27-next-learning-steps)

---

## 1. Installing Python

The bot is written in **Python 3.12+**.

### Windows

1. Go to <https://www.python.org/downloads/> - the site auto-detects Windows and shows a **Download Python 3.x.x** button.
2. Run the downloaded installer.
3. **Critical step:** on the first installer screen, check the box **"Add python.exe to PATH"** at the bottom before clicking **Install Now**.

   `[SCREENSHOT: Python installer with "Add python.exe to PATH" checkbox highlighted]`
4. Wait for the install to finish, then click **Close**.
5. Open **Command Prompt** (press `Win`, type `cmd`, press Enter) and run:

   ```bat
   python --version
   ```

   Expected output:

   ```
   Python 3.12.4
   ```

### macOS

1. Go to <https://www.python.org/downloads/macos/> and download the latest **macOS 64-bit universal2 installer**.
2. Open the downloaded `.pkg` file and follow the installer prompts (Continue -> Continue -> Agree -> Install).
3. Open **Terminal** (press `Cmd+Space`, type `Terminal`, press Enter) and run:

   ```bash
   python3 --version
   ```

   Expected output:

   ```
   Python 3.12.4
   ```

> If `python`/`python3` is not recognized, restart your terminal (or your computer) and try again - this refreshes your PATH.

---

## 2. Installing Visual Studio Code

1. Go to <https://code.visualstudio.com/> and click the big **Download** button for your OS.
2. Run the installer:
   - **Windows:** double-click the `.exe`, accept the license, keep the default options (make sure **"Add to PATH"** stays checked), click **Install**, then **Finish**.
   - **macOS:** open the downloaded `.zip`, drag **Visual Studio Code.app** into your **Applications** folder.
3. Launch VS Code.

   `[SCREENSHOT: VS Code welcome screen]`

---

## 3. Installing Git

Git lets you download ("clone") this repository and track changes.

### Windows

1. Download the installer from <https://git-scm.com/download/win>.
2. Run it and click **Next** through every screen (the defaults are fine for beginners).
3. Open a **new** Command Prompt and run:

   ```bat
   git --version
   ```

   Expected output: `git version 2.4x.x.windows.1`

### macOS

1. Open Terminal and run:

   ```bash
   git --version
   ```

2. If Git isn't installed, macOS will prompt you to install the **Xcode Command Line Tools** - click **Install** and wait for it to finish.

---

## 4. Installing required VS Code extensions

Open VS Code, click the **Extensions** icon in the left sidebar (four squares icon, or press `Ctrl+Shift+X` / `Cmd+Shift+X`), and install each of these by searching its name and clicking **Install**:

| Extension | Publisher | Why you need it |
|---|---|---|
| Python | Microsoft | Python language support, run/debug button |
| Pylance | Microsoft | Fast autocomplete and error checking |
| Ruff | Astral Software | Linting/formatting (matches this project's style) |
| Python Debugger | Microsoft | Lets you use the included `Run Discord AI Bot` debug config |

`[SCREENSHOT: VS Code Extensions panel with "Python" search results]`

> Tip: this repository includes a `.vscode/extensions.json` file. When you open the project folder (next step), VS Code will show a notification: **"This workspace has extension recommendations"** - click **Install All** to grab everything at once.

---

## 5. Opening the project

### 5.1 Clone the repository

Open a terminal (Command Prompt on Windows, Terminal on macOS) and run:

```bash
git clone <YOUR_REPOSITORY_URL> discord-ai-bot
cd discord-ai-bot
```

> Replace `<YOUR_REPOSITORY_URL>` with the actual GitHub URL (e.g. `https://github.com/your-username/discord-ai-bot.git`). If you downloaded a ZIP instead, extract it and skip the `git clone` line.

### 5.2 Open it in VS Code

```bash
code .
```

If `code .` doesn't work, open VS Code manually, click **File -> Open Folder...**, and select the `discord-ai-bot` folder.

`[SCREENSHOT: VS Code File Explorer showing the discord-ai-bot folder structure]`

---

## 6. Creating a virtual environment

A **virtual environment** is an isolated Python installation just for this project, so its dependencies never conflict with other projects on your computer.

In VS Code, open a terminal: **Terminal -> New Terminal** (or `` Ctrl+` ``).

### Windows

```bat
python -m venv .venv
```

### macOS

```bash
python3 -m venv .venv
```

This creates a `.venv` folder inside the project. Expected output: no errors, and a new `.venv` folder appears in the file explorer on the left.

---

## 7. Activating the virtual environment

You must activate the virtual environment **every time** you open a new terminal to work on this project.

### Windows (Command Prompt)

```bat
.venv\Scripts\activate
```

### Windows (PowerShell)

```powershell
.venv\Scripts\Activate.ps1
```

> If PowerShell blocks the script with an execution-policy error, run this once: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, type `Y`, then retry.

### macOS

```bash
source .venv/bin/activate
```

**How to know it worked:** your terminal prompt now starts with `(.venv)`, e.g.:

```
(.venv) C:\Users\you\discord-ai-bot>
```

---

## 8. Installing dependencies

With the virtual environment activated, run:

```bash
pip install -r requirements.txt
```

Expected output ends with something like:

```
Successfully installed aiosqlite-0.20.0 discord.py-2.4.0 fastapi-0.115.6 ...
```

This installs everything listed in `requirements.txt`: `discord.py`, `fastapi`, `uvicorn`, `openai`, `pydantic`, `pydantic-settings`, `python-dotenv`, and `aiosqlite`.

---

## 9. Creating the .env file

The `.env` file stores your secret keys and configuration. It is never uploaded to GitHub (it's excluded via `.gitignore`).

1. In VS Code's file explorer, copy `.env.example`.
2. Paste it in the same folder and rename the copy to exactly `.env`.

   Or from the terminal:

   ```bash
   # Windows
   copy .env.example .env
   # macOS
   cp .env.example .env
   ```
3. Open `.env` in VS Code and fill in the blank values as you complete the steps below. At minimum you need `DISCORD_BOT_TOKEN` and `OPENAI_API_KEY`.

| Variable | Required | Where to get it |
|---|---|---|
| `DISCORD_BOT_TOKEN` | ✅ Yes | Step 13 below |
| `DISCORD_GUILD_ID` | Optional (recommended for testing) | Step 13 below |
| `OPENAI_API_KEY` | ✅ Yes | Step 10 below |
| `WEBHOOK_SECRET` | Recommended | Any random string you invent |
| Everything else | Has sensible defaults | No action needed |

---

## 10. Obtaining OpenAI API keys

1. Go to <https://platform.openai.com/> and sign up or log in.
2. Click your profile icon (top right) -> **View API keys**, or go directly to <https://platform.openai.com/api-keys>.
3. Click **Create new secret key**, give it a name like `discord-ai-bot`, and click **Create secret key**.

   `[SCREENSHOT: OpenAI API Keys page with "Create new secret key" button]`
4. **Copy the key immediately** - OpenAI only shows it once. It looks like `sk-proj-...`.
5. Paste it into your `.env` file:

   ```
   OPENAI_API_KEY=sk-proj-your-real-key-here
   ```
6. Make sure your OpenAI account has billing set up (**Settings -> Billing**) - the Responses API requires a funded or trial account.

---

## 11. Setting up Google Cloud (if required)

**Not required for this project.** Discord AI Bot does not use any Google Cloud services out of the box. You can skip this section entirely.

---

## 12. Setting up a Telegram Bot (if applicable)

**Not applicable.** This project targets Discord only, not Telegram. Skip this section.

---

## 13. Setting up a Discord Bot

### 13.1 Create the application

1. Go to <https://discord.com/developers/applications> and log in with your Discord account.
2. Click **New Application**, give it a name (e.g. `Discord AI Bot`), accept the terms, and click **Create**.

   `[SCREENSHOT: Discord Developer Portal "New Application" dialog]`

### 13.2 Create the bot user and get your token

1. In the left sidebar, click **Bot**.
2. Click **Reset Token** (or **Add Bot** if this is the first time), confirm, then click **Copy** to copy the token.

   `[SCREENSHOT: Discord Developer Portal Bot page with "Reset Token" and "Copy" buttons]`
3. Paste it into `.env`:

   ```
   DISCORD_BOT_TOKEN=your-copied-token-here
   ```

> ⚠️ Treat this token like a password. Anyone with it can control your bot.

### 13.3 Enable required intents

Still on the **Bot** page, scroll to **Privileged Gateway Intents** and turn ON:

- **Message Content Intent**

Click **Save Changes**.

### 13.4 Invite the bot to your server

1. In the left sidebar, click **OAuth2 -> URL Generator**.
2. Under **Scopes**, check `bot` and `applications.commands`.
3. Under **Bot Permissions**, check: `Send Messages`, `Read Message History`, `Manage Messages`, `Embed Links`, `Use Slash Commands`.
4. Copy the generated URL at the bottom, paste it into your browser, choose your server, and click **Authorize**.

   `[SCREENSHOT: Discord OAuth2 URL Generator with Scopes and Bot Permissions checked]`

### 13.5 (Recommended) Get your Guild (server) ID for instant command sync

1. In Discord, open **User Settings -> Advanced** and enable **Developer Mode**.
2. Right-click your server's icon -> **Copy Server ID**.
3. Paste it into `.env`:

   ```
   DISCORD_GUILD_ID=123456789012345678
   ```

   This makes slash commands appear **instantly** in that server instead of waiting up to an hour for a global sync.

---

## 14. Configuring OAuth credentials (if applicable)

**Not applicable.** The Discord bot token from Step 13 is all the authentication this project needs. There is no separate OAuth client/secret to configure.

---

## 15. Running the application

You have two options:

### Option A - One-click startup script (easiest)

- **Windows:** double-click **`Start App.bat`** in the project folder.
- **macOS:** double-click **`Start App (Mac).command`** in the project folder (Finder may ask you to confirm opening it the first time - click **Open**).

Both scripts automatically create the virtual environment, install dependencies, check your `.env` file, and start the bot.

### Option B - Manual (from VS Code terminal)

With your virtual environment activated (Step 7):

```bash
python -m app.main
```

### Expected output

```
2026-07-18 10:00:00 | INFO     | app.main | Starting Discord AI Bot...
2026-07-18 10:00:00 | INFO     | app.infrastructure.database | Database ready at data/bot.db
2026-07-18 10:00:01 | INFO     | app.interfaces.discord_bot | Loaded cog: ChatCog
2026-07-18 10:00:01 | INFO     | app.interfaces.discord_bot | Loaded cog: SummarizeCog
...
2026-07-18 10:00:02 | INFO     | app.interfaces.discord_bot | Synced 7 slash commands to guild 123456789012345678 (instant).
2026-07-18 10:00:02 | INFO     | app.interfaces.discord_bot | Logged in as Discord AI Bot#1234 (id=987654321098765432)
INFO:     Uvicorn running on http://0.0.0.0:8000
```

Your bot is now online in Discord, and the automation API is available at `http://localhost:8000`.

Press `Ctrl+C` in the terminal to stop it.

---

## 16. Running the automation workflows

This project ships automation examples for **n8n**, **Zapier**, and **Make**. All three work the same way: they call your bot's HTTP API at `/automation/*`.

For any automation tool that is **not running on the same computer** as your bot, you need to make `http://localhost:8000` reachable from the internet. The easiest free way is [ngrok](https://ngrok.com/download):

```bash
ngrok http 8000
```

This prints a public HTTPS URL like `https://a1b2c3d4.ngrok-free.app` - use that instead of `localhost:8000` in the workflow steps below.

---

## 17. Importing the n8n workflow

1. Install/open n8n (self-hosted or [n8n.cloud](https://n8n.io/cloud/)).
2. Create a new workflow, then use the menu (**...** in the top right) -> **Import from File**.
3. Select `workflows/n8n/discord-ai-bot-workflow.json` from this repository.
4. Follow the detailed setup steps in `workflows/n8n/README.md` (set your bot's URL and webhook secret, add a Discord channel webhook).
5. Activate the workflow.

---

## 18. Setting up the Zapier Zap

Zapier doesn't support importing Zaps from a file, so follow the click-by-click guide instead:

1. Open `workflows/zapier/zapier-setup-guide.md`.
2. Follow each numbered step to recreate the Zap in the Zapier UI (Trigger -> Webhooks by Zapier POST -> Google Sheets update).
3. Use `workflows/zapier/zap-blueprint.json` as a reference for exact field names/values.

---

## 19. Importing the Make scenario

1. Log into [make.com](https://www.make.com).
2. Create a new scenario, then use the **...** menu -> **Import Blueprint**.
3. Select `workflows/make/discord-ai-bot-scenario.json`.
4. Follow `workflows/make/make-setup-guide.md` to finish configuring the webhook URL and secret.
5. Turn the scenario **ON**.

---

## 20. Testing every feature

With the bot running (Step 15) and invited to your server (Step 13.4), go into Discord and try each command:

| Command | Try this | Expected result |
|---|---|---|
| `/help` | `/help` | An embed listing every command. |
| `/chat` | `/chat message: What's a good name for a cat?` | An AI-generated reply within a few seconds. |
| `/summarize` | `/summarize text: <paste a few paragraphs>` | A short bullet/sentence summary embed. |
| `/translate` | `/translate text: Hello there language: French` | `Bonjour` (or similar) in an embed. |
| `/settings` | `/settings persona persona: coder` | Confirmation message; future `/chat` replies act like a senior engineer. |
| `/history` | `/history action: view` | Your last few messages with the bot. |
| `/moderate` | `/moderate text: I love sunny days` | "clean" result with no flagged categories. |
| `/purge` | `/purge amount: 5` | Deletes the last 5 messages in the channel (requires Manage Messages permission). |

### Testing the automation API directly

```bash
curl http://localhost:8000/health
```

Expected output:

```json
{"status":"ok","bot_ready":true}
```

```bash
curl -X POST http://localhost:8000/automation/chat \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Secret: change-me" \
  -d '{"message": "Say hello in 5 words", "user_id": "test-user"}'
```

Expected output:

```json
{"reply": "Hello! Great to meet you."}
```

> Replace `change-me` with your real `WEBHOOK_SECRET` value if you changed it.

---

## 21. Common errors

| Error message | Cause | Fix |
|---|---|---|
| `'python' is not recognized as an internal or external command` | Python isn't on PATH | Reinstall Python and check "Add python.exe to PATH" (Step 1) |
| `ModuleNotFoundError: No module named 'discord'` | Dependencies not installed, or venv not activated | Run Step 7 then Step 8 again |
| `discord.errors.LoginFailure: Improper token has been passed` | Wrong/empty `DISCORD_BOT_TOKEN` | Re-copy the token from Step 13.2 |
| `openai.AuthenticationError: Incorrect API key provided` | Wrong/empty `OPENAI_API_KEY` | Re-copy the key from Step 10 |
| Slash commands don't appear in Discord | Global sync can take up to 1 hour | Set `DISCORD_GUILD_ID` (Step 13.5) for instant sync |
| `401 Unauthorized` calling `/automation/*` | Missing/incorrect `X-Webhook-Secret` header | Match the header to `WEBHOOK_SECRET` in `.env` |
| `sqlite3.OperationalError: unable to open database file` | The `data/` folder doesn't exist or isn't writable | Make sure you're running the app from the project root folder |
| PowerShell: `cannot be loaded because running scripts is disabled` | Windows execution policy | Run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once |

---

## 22. Troubleshooting

- **Nothing happens when I run the bot.** Check the terminal for red `ERROR` lines - they explain exactly what failed. Scroll up if the window is full of text.
- **The bot goes online but slash commands time out.** Make sure `Message Content Intent` is enabled (Step 13.3) and that you invited the bot with the `applications.commands` scope (Step 13.4).
- **I edited `.env` but nothing changed.** Restart the app - environment variables are only read once, at startup.
- **`pip install` is very slow or fails.** Check your internet connection, or try `pip install -r requirements.txt --timeout 60`.
- **I'm on Apple Silicon (M1/M2/M3) and something won't install.** Make sure you downloaded the "universal2" Python installer in Step 1.
- **Still stuck?** Re-run the one-click startup script (Step 15, Option A) - it re-checks every prerequisite and tells you exactly what's missing.

---

## 23. Project architecture

This project uses **Clean Architecture**: business logic never depends on frameworks.

```
Discord user / Automation tool
        │
        ▼
interfaces/   (Discord cogs, FastAPI routes) - "how the outside world talks to us"
        │
        ▼
application/  (chat, summarize, translate, moderation, memory, settings services) - "what the app does"
        │
        ▼
infrastructure/ (OpenAI client, SQLite repositories, logging, webhooks) - "how we talk to the outside world"
        │
        ▼
domain/       (Pydantic models: ConversationMessage, UserSettings, Persona) - "what things ARE"
```

Because `application/` only depends on `domain/` and abstractions, you could
swap SQLite for PostgreSQL, or discord.py for a Slack SDK, by only touching
`infrastructure/` and `interfaces/` - the core logic never changes.

---

## 24. Folder structure

```
discord-ai-bot/
├── app/
│   ├── domain/models.py # Data models
│   ├── application/ # Use-case services + prompt templates
│   ├── infrastructure/ # OpenAI client, database, repositories, logging
│   ├── interfaces/
│   │   ├── cogs/ # One file per Discord command group
│   │   └── api/ # FastAPI routes/schemas/security
│   ├── container.py # Dependency injection wiring
│   ├── config.py # Environment-based settings
│   └── main.py # Entrypoint
├── tests/ # Unit tests (pytest)
├── workflows/
│   ├── n8n/ # Importable n8n workflow JSON + guide
│   ├── zapier/ # Zap setup guide + reference blueprint
│   └── make/ # Importable Make blueprint + guide
├── assets/logo.svg # Project logo
├── data/ # SQLite database file (auto-created)
├── .vscode/ # VS Code settings, extensions, debug config
├── .env.example # Environment variable template
├── requirements.txt # Runtime dependencies
├── requirements-dev.txt # + pytest
├── Start App.bat # Windows launcher
├── Start App (Mac).command # macOS launcher
├── README.md
└── INSTRUCTION.md # This file
```

---

## 25. FAQ

**Q: Do I need a paid OpenAI plan?**
A: You need billing configured on your OpenAI account, but usage is pay-as-you-go - a small testing budget (a few dollars) is enough to try every feature.

**Q: Can I run this bot on more than one Discord server?**
A: Yes - after you invite it to additional servers (repeat Step 13.4), remove `DISCORD_GUILD_ID` from `.env` so commands sync globally, or add multi-guild sync logic yourself.

**Q: Where is conversation history stored?**
A: In a local SQLite file at `data/bot.db`. Users can clear their own history any time with `/history clear`.

**Q: Can I change the AI's personality?**
A: Yes - `/settings persona` lets each user choose between default, friendly, professional, coder, and concise. Edit `app/application/prompt_templates.py` to add your own.

**Q: Can I deploy this to a server instead of running it on my laptop?**
A: Yes. Any host that can run Python 3.12 and keep a process alive works (a VPS, Railway, Fly.io, etc.). Set your environment variables there instead of a local `.env` file, and make sure port 8000 (or your chosen `API_PORT`) is reachable if you use the automation endpoints.

**Q: Why does the bot use both discord.py AND FastAPI?**
A: discord.py handles the Discord connection; FastAPI exposes the same AI features over HTTP so n8n/Zapier/Make can use them too - both run in the same process, sharing one database and one OpenAI client.

---

## 26. Security best practices

- **Never commit `.env`** - it's already in `.gitignore`, but double-check before pushing to GitHub.
- **Rotate tokens if leaked.** If you ever accidentally share your `DISCORD_BOT_TOKEN` or `OPENAI_API_KEY`, regenerate them immediately in the Discord Developer Portal / OpenAI dashboard.
- **Use a strong `WEBHOOK_SECRET`.** Generate one with:

  ```bash
  python -c "import secrets; print(secrets.token_urlsafe(32))"
  ```
- **Limit bot permissions** to only what's needed (Step 13.4) - avoid granting Administrator.
- **Restrict `/moderate` and `/purge`** - they already require the Manage Messages permission; don't grant that role broadly.
- **Keep dependencies updated** with `pip install -r requirements.txt --upgrade` periodically, and watch for security advisories on the packages you use.
- **Don't expose your automation API publicly without HTTPS** - use a tunnel (ngrok) or a reverse proxy with TLS in production.

---

## 27. Next learning steps

Once you're comfortable running and using the bot:

1. **Learn Python basics** - [official Python tutorial](https://docs.python.org/3/tutorial/).
2. **Learn async/await** - this project is fully asynchronous; understanding `async def`/`await` will help you extend it. See [Real Python's asyncio guide](https://realpython.com/async-io-python/).
3. **Explore FastAPI** - [official FastAPI tutorial](https://fastapi.tiangolo.com/tutorial/) to add new automation endpoints.
4. **Explore discord.py** - [official docs](https://discordpy.readthedocs.io/) to add new commands/cogs.
5. **Learn Git basics** - commit, branch, push/pull - [GitHub's Git handbook](https://guides.github.com/introduction/git-handbook/).
6. **Try adding a new persona or command** - start in `app/application/prompt_templates.py` or copy an existing file in `app/interfaces/cogs/`.
7. **Explore the OpenAI Responses API** - [official docs](https://platform.openai.com/docs/api-reference/responses) for advanced features like tool calling and structured outputs.

Happy building! 🎉
