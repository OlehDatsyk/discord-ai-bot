<p align="center">
  <img src="assets/logo.svg" alt="Discord AI Bot logo" width="240">
</p>

<h1 align="center">Discord AI Bot</h1>

<p align="center">
  A production-ready Discord bot with AI chat, moderation, summarization,
  translation, conversation memory, and no-code automation via n8n, Zapier,
  and Make - built with Clean Architecture, FastAPI, discord.py, and the
  OpenAI Responses API.
</p>

<p align="center">
  <b>New to Python, VS Code, or Git?</b> Skip straight to
  <a href="INSTRUCTION.md"><b>INSTRUCTION.md</b></a> - a complete zero-to-running
  guide for absolute beginners.
</p>

---

## Features

| Feature | Description |
|---|---|
| AI Chat | `/chat` - conversational AI with persistent, per-user, per-channel memory. |
| Summarization | `/summarize` - condense long text into key points. |
| Translation | `/translate` - translate text into any language. |
| Moderation | `/moderate`, `/purge` - AI-assisted content flagging and bulk message deletion. |
| Conversation memory | Recent turns are stored in SQLite and replayed as context on every request. |
| Prompt templates (personas) | `/settings persona` - default, friendly, professional, coder, concise. |
| Automation | REST endpoints for n8n, Zapier, and Make to trigger AI features from outside Discord. |

## Commands

| Command | Description |
|---|---|
| `/help` | List all available commands. |
| `/chat <message>` | Chat with the AI assistant. |
| `/summarize <text>` | Summarize a block of text. |
| `/translate <text> <language>` | Translate text into another language. |
| `/settings view\|persona\|language\|model` | View or change your preferences. |
| `/history view\|clear` | View or clear your stored conversation history. |
| `/moderate <text>` | Check text against OpenAI's moderation categories (requires Manage Messages). |
| `/purge <amount>` | Bulk-delete recent messages (requires Manage Messages). |

## Architecture

This project follows **Clean Architecture**: dependencies point inward, and
the core business logic never imports framework code directly.

```
app/
├── domain/ # Pure data models (Pydantic). No framework imports.
├── application/ # Use-case services (chat, summarize, translate, moderation, memory, settings).
├── infrastructure/ # Concrete implementations: OpenAI client, SQLite repositories, logging, webhooks.
├── interfaces/ # Delivery mechanisms: Discord cogs and the FastAPI automation API.
│   ├── cogs/ # One file per Discord slash-command group.
│   └── api/ # FastAPI routes, schemas, and webhook auth.
├── container.py # Composition root - wires every dependency together once.
├── config.py # Environment-variable driven settings (Pydantic v2).
└── main.py # Entrypoint: runs the bot and the API concurrently.
```

```
                 ┌────────────────────┐
   Discord  ───▶ │   interfaces/       │
   users         │   cogs/*.py          │
                 └─────────┬───────────┘
                           │
   n8n / Zapier /   ┌──────▼───────────┐        ┌───────────────────┐
   Make webhooks ──▶│  interfaces/api/   │─────▶ │  application/       │
                 │  routes.py            │       │  *_service.py        │
                 └───────────────────────┘       └─────────┬───────────┘
                                                              │
                                              ┌───────────────▼───────────────┐
                                              │  infrastructure/                │
                                              │  openai_client.py, database.py,  │
                                              │  *_repository.py, webhook_notifier│
                                              └─────────────────┬───────────────┘
                                                                 │
                                                   ┌─────────────▼─────────────┐
                                                   │  OpenAI Responses API +      │
                                                   │  SQLite database              │
                                                   └────────────────────────────┘
```

## Requirements

- Python 3.12+
- A [Discord bot token](https://discord.com/developers/applications)
- An [OpenAI API key](https://platform.openai.com/api-keys)

## Quick start

```bash
git clone <your-fork-url> discord-ai-bot
cd discord-ai-bot
python -m venv .venv
source .venv/bin/activate # Windows: .venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env # then fill in DISCORD_BOT_TOKEN and OPENAI_API_KEY
python -m app.main
```

Or simply double-click **`Start App.bat`** (Windows) or **`Start App (Mac).command`**
(macOS) after cloning - both scripts set everything up automatically.

Full beginner-friendly walkthrough: **[INSTRUCTION.md](INSTRUCTION.md)**.

## Automation (n8n / Zapier / Make)

The bot exposes a small HTTP API (FastAPI) alongside the Discord client so
external automation tools can trigger AI features without a Discord user
being involved:

| Endpoint | Purpose |
|---|---|
| `GET /health` | Health check (no auth required). |
| `POST /automation/chat` | Send a message, get an AI reply. |
| `POST /automation/summarize` | Summarize arbitrary text. |
| `POST /automation/translate` | Translate arbitrary text. |
| `POST /automation/moderate` | Run OpenAI moderation on arbitrary text. |

All `/automation/*` routes require an `X-Webhook-Secret` header matching
`WEBHOOK_SECRET` in your `.env` file. Interactive API docs are available at
`http://localhost:8000/docs` while the app is running.

Ready-to-use workflow files live in [`workflows/`](workflows):

- [`workflows/n8n/`](workflows/n8n) - an importable n8n workflow JSON.
- [`workflows/zapier/`](workflows/zapier) - a step-by-step Zap guide (Zapier
  does not support JSON import, so a reference blueprint + click-by-click
  guide is provided instead).
- [`workflows/make/`](workflows/make) - an importable Make.com scenario blueprint.

## Testing

```bash
pip install -r requirements-dev.txt
pytest
```

## Project structure

```
discord-ai-bot/
├── app/ # Application source code (Clean Architecture)
├── tests/ # Unit tests
├── workflows/ # n8n / Zapier / Make automation examples
├── assets/ # SVG logo
├── data/ # SQLite database (created automatically)
├── .env.example # Environment variable template
├── .vscode/ # VS Code recommended settings/extensions
├── requirements.txt # Runtime dependencies
├── requirements-dev.txt # + testing dependencies
├── Start App.bat # Windows one-click launcher
├── Start App (Mac).command # macOS one-click launcher
├── INSTRUCTION.md # Full beginner setup guide
└── README.md # This file
```

## Security notes

- Never commit your `.env` file - it is already excluded via `.gitignore`.
- Rotate `WEBHOOK_SECRET` and your OpenAI/Discord keys if they are ever exposed.
- The `/moderate` and `/purge` commands require the Discord **Manage Messages**
  permission.

## License

[MIT](LICENSE)
