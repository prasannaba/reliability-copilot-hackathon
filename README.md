# Reliability Copilot — Meta Hackathon submission (event work only)

**Before Oct 26, 2026, I had `reliability-ai-agent` (the app inside it was already called Reliability Copilot), a private v3.9.0 Weibull-analysis agent; during this hackathon I built the single-agent reliability system described below on top of that pinned baseline — this repository contains only that event work.**

## Why this repo contains no application source code

Per the hackathon rule for pre-existing projects, the submitted repo must hold
only work done during the event. The pre-event code is **not** copied here.

| Piece | Where it lives |
|---|---|
| Pre-event engine (baseline) | Public repo: https://github.com/prasannaba/reliability-ai-agent |
| Pinned baseline commit | `02f2b6b93284cf1478abc79cdd3145b24576b5b8` — "Slim Docker image with CPU torch default plus CUDA overlay, fix Settings model refresh (v3.9.0)", 2026-09-28, on branch `main` |
| Event work (Oct 28 – Nov 2, 2026) | `patches/reliability-copilot-event.patch` in this repo (245 files changed vs. the pinned baseline, including removal of a personal bio note from the knowledge base) |
| Assembly | `setup.ps1` (Windows) / `setup.sh` (Linux/macOS) clone the pinned baseline and apply the patch, producing the runnable app in `app/` |

The full commit-by-commit development narrative (51 commits, Oct 28 – Nov 2,
plus cleanup) is preserved in [EVENT_LOG.md](EVENT_LOG.md), including how each
dev-repo commit maps into this submission.

The patch was generated from the development repo with:

```bash
git diff --binary --full-index 02f2b6b93284cf1478abc79cdd3145b24576b5b8 <event-final-commit>
# event-final-commit = ba9a67f0197a6a56982fb5c44042fdfe15e225ed (private dev repo reliability-copilot, 2026-11-03, v5.1.1 + knowledge-base cleanup + Docker fixes + warranty/demo planning tools + home-screen chips for them)
```

Everything in the patch is therefore, by construction, a change made on top of
the public pre-event baseline. Unchanged baseline files (the original Weibull
fit path, seed knowledge-base notes, report-export skeleton, chat UI shell,
FastAPI/MCP host skeleton) come from the baseline clone — never from this repo.

## What existed before the event (baseline v3.9.0, not claimed as new)

- FastAPI host + pluggable MCP domain servers (reliability + physics)
- Original 2-parameter Weibull RRY fit, B-life/MTBF tools, probability plot
- Hybrid RAG knowledge base (Chroma + BM25) over seed reliability notes
- Markdown report-export skeleton
- React/TypeScript chat UI shell with SSE streaming and model picker
- Docker / docker-compose packaging

## What was built during the event (in the patch)

- **Single-agent loop**: plan/ask modes replaced by one Agent mode with a
  conversation ledger, code-enforced grounding guard (numeric claims must
  trace to tool results), deterministic plot filenames, Meta/Baseten
  (Meta Muse Spark) provider support
- **New deterministic tools (14 total)**: warranty failure forecasting (Weibull CDF + binomial interval) and zero-failure demonstration-test planning added late in the event; also multi-distribution censored-MLE
  fitting with AIC ranking (`fit_life_distribution`, `select_life_distribution`),
  Kaplan–Meier nonparametric analysis, NIST exploratory-data-analysis 4-plots,
  Duane + Crow-AMSAA reliability growth + MTBF forecast, deterministic
  frequency-table parser (`parse_life_data_table`)
- **Weibull probability paper** rebuilt against reference paper (correct
  ln-ln scale, bootstrap band, β gauge) with regression tests
- **Knowledge base**: NIST *Assessing Product Reliability* and NIST/SEMATECH
  EDA handbook added as citable sources; MiniLM embedder warm-up
- **Frontend**: KaTeX math rendering, plot lightbox, demo hero/samples,
  streaming-display optimisation, single reliability domain (physics domain
  and domain switching removed)
- **Packaging/docs**: Docker-first quick start, hackathon demo assets and
  provenance documentation

The LLM never invents engineering metrics: β, η, MTBF, B-life and plot data
come only from the deterministic Python/MCP tools. Reports render tool
outputs without recalculating.

## Judge setup — run the project from this repo

Prerequisites: Git, Docker Desktop (recommended path). No Python/Node needed
for the Docker path.

### Windows (PowerShell)

```powershell
git clone https://github.com/prasannaba/reliability-copilot-hackathon.git
cd reliability-copilot-hackathon
.\setup.ps1            # clones pinned baseline into .\app and applies the event patch
cd app
copy .env.example .env # set LLM_API_BASE + LLM_API_KEY (e.g. Baseten) — never commit .env
docker compose up --build -d
# Wait for startup: first boot loads the embedding model (30-60s). "Empty
# reply from server" from curl in that window is expected — retry, or check
# `docker compose ps` until app shows (healthy).
1..30 | % { curl.exe -s http://localhost:8000/health; if ($LASTEXITCODE -eq 0) { break }; sleep 2 }
# UI: http://localhost:8000
```

### Linux / macOS

```bash
git clone https://github.com/prasannaba/reliability-copilot-hackathon.git
cd reliability-copilot-hackathon
./setup.sh             # clones pinned baseline into ./app and applies the event patch
cd app
cp .env.example .env   # set LLM_API_BASE + LLM_API_KEY — never commit .env
docker compose up --build -d
# Wait for startup: first boot loads the embedding model (30-60s). "Empty
# reply from server" from curl in that window is expected — retry, or check
# `docker compose ps` until app shows (healthy).
for i in $(seq 1 30); do curl -s http://localhost:8000/health && break || sleep 2; done
# UI: http://localhost:8000
```

### Verify the assembly (optional)

```bash
git -C app rev-parse HEAD
# -> 02f2b6b93284cf1478abc79cdd3145b24576b5b8 (baseline checked out; event work is the applied working-tree patch)
git -C app status --short   # shows exactly the files the event patch touches
```

Backend tests inside the assembled app (requires Python 3.12 + `uv`):

```bash
cd app/backend && uv sync --all-groups && uv run pytest
```

### Running locally without Docker (optional)

Use `app/scripts/run.ps1` (Windows) or `app/scripts/run.sh` — it builds the
frontend into `app/backend/static/ui` first if needed, then starts the
backend at http://localhost:8000. If you start the backend directly
(`scripts/start.ps1` or `uv run python -m src.host.app`) without building
the UI, the API still works but the browser will show
`{"ui": "not built", ...}` — run `app/scripts/build_ui.ps1` once and
restart the backend to fix that.

## Repository contents

```text
reliability-copilot-hackathon/
├── README.md                              # this file
├── EVENT_LOG.md                           # 51-commit development narrative + mapping to this repo
├── setup.ps1 / setup.sh                   # clone pinned baseline + apply patch -> app/
├── patches/
│   └── reliability-copilot-event.patch    # all event changes vs. pinned baseline (binary-safe)
└── .gitignore                             # app/ and .env are generated/local, never committed
```

`app/` is a generated assembly directory. It is git-ignored and is not part of
the submission.

## Data handling

The assembled app is intended for local/controlled use. If a remote LLM
endpoint is configured, prompt context is transmitted to that provider; do
not claim data stays on-device for such a deployment. Use only synthetic or
approved data for demonstrations. No secrets are contained in this repo or
in the patch.

## License

The assembled application is distributed under the license in the baseline
repository (MIT, see `app/LICENSE` after setup).
