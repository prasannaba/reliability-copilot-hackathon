# Event log — development history of the submitted work

This file preserves the commit-by-commit development narrative of the
hackathon work without copying any pre-event code or git history into this
repository.

- **Development repo (private during the event):** `reliability-copilot`
- **Development period:** 2026-10-28 to 2026-11-02 (plus a knowledge-base
  cleanup on 2026-11-03)
- **Commits:** 51 (`e1c1989` … `ba9a67f`, branch `master`)
- **Hashes below** refer to that development repo. They are listed so the
  work can be audited against it after the event; they are not commits in
  this submission repository.

## How this log maps to the submission

| Dev-repo history | Submission equivalent |
|---|---|
| `9378bcd` imported the pre-event baseline v3.9.0 into the dev repo so work could start from a runnable tree | **Not replayed and not copied.** Replaced by `setup.ps1` / `setup.sh`, which clone the public baseline repo and check out the pinned commit `02f2b6b93284cf1478abc79cdd3145b24576b5b8` |
| All other commits (`e1c1989`, `87e7973`, and everything after `9378bcd`) | Netted into `patches/reliability-copilot-event.patch` = `git diff --binary 02f2b6b..ba9a67f` (245 files). Intermediate states that were later superseded (e.g. plan/ask modes in `cff791f`, removed in `eb802e0` / `04b26a4`) appear only as their net effect in the final patch |
| Final tree at `ba9a67f` | Reproduced by running the setup scripts (verified 2026-11-03 at `1a75c79`: assembled tree matched the dev repo tree file-for-file, backend tests 192 passed / 1 skipped; `2769c69` + `74486bd` are Docker ownership/volume fixes re-verified by clean-room Docker tests: Settings save HTTP 200 and the UI serving real HTML; `6ad3188`/`2385fc1`/`5df36f0` adjust home-screen sample prompts; `bbe5559` documents the Docker startup wait; `b1aac1f` adds the warranty-forecast and demonstration-test planning tools (13 tests); `ba9a67f` showcases them as home-screen sample chips) |

The dev repo's own `README.md`, `ARCHITECTURE.md`, `SKILLS_INDEX.md` and
`AGENTS.md` are part of the final tree and therefore travel inside the
patch — after setup they are readable at `app/README.md`,
`app/ARCHITECTURE.md`, etc.

## Themes

- **Agent and chat:** Meta/Baseten providers (`f827cc8`), single Agent mode
  with conversation ledger and grounding guard (`eb802e0`, `920b537`,
  `f73c81a`), streaming fixes (`812a140`, `6fd27bf`)
- **Calculations and plots:** calculation-layer consolidation (`1926258`),
  Duane + Crow-AMSAA growth (`7cd64c4`), distribution selection / Kaplan-Meier /
  EDA (`cff791f`), Weibull paper rebuild and hardening (`5600fc9`, `5bf3dc2`)
- **Knowledge:** NIST reliability + EDA handbooks added (`cff791f`)
- **Frontend:** composer/a11y/model-picker polish, demo hero, KaTeX + plot
  lightbox (`c705a63`), video/streaming optimisation (5.1.0, `6eb7815`)
- **Simplification:** single reliability domain, physics domain removed
  (`04b26a4`, `f8363f5`)

## Full commit list (oldest first)

| # | Date | Commit | Subject |
|---|---|---|---|
| 1 | 2026-10-28 | `e1c1989` | docs: add initial project documentation |
| 2 | 2026-10-30 | `87e7973` | docs: add SKILLS_INDEX.md and update AGENTS.md guidelines |
| 3 | 2026-10-30 | `9378bcd` | feat: clean fork from reliability-ai-agent v3.9.0 — runnable baseline *(baseline import; replaced by setup-script clone in this submission)* |
| 4 | 2026-10-30 | `1926258` | refactor(reliability): consolidate calculation layer into plotting + weibull_fit |
| 5 | 2026-10-30 | `50cb8e9` | refactor(host): extract ReAct/think parsing into host/thinking.py |
| 6 | 2026-10-30 | `ed11a9b` | feat(frontend): a11y polish for composer and sidebar |
| 7 | 2026-10-30 | `7cd64c4` | feat(reliability): add Duane + Crow-AMSAA growth models |
| 8 | 2026-10-30 | `9d459e2` | ci(demo): add CI, demo dataset, and growth skill docs |
| 9 | 2026-10-31 | `5932583` | chore(release): bump to 3.10.0 — Duane + Crow-AMSAA, a11y, CI |
| 10 | 2026-10-31 | `f827cc8` | feat(llm): add Meta + Baseten providers, default to Baseten, add /v1/responses suffix, remove .llm_config persistence |
| 11 | 2026-10-31 | `f6aa291` | chore: remove commercial-solver disclaimer per review |
| 12 | 2026-10-31 | `05c86b2` | chore: remove ReliaSoft disclaimer, untrack generated report |
| 13 | 2026-10-31 | `e3b4fff` | chore(release): bump to 3.10.1 |
| 14 | 2026-10-31 | `e84fe7b` | fix(weibull): start probability plot x-axis at 10^0 (1) not 10^-1 (0.1) |
| 15 | 2026-10-31 | `42daf21` | feat(chat): per-session prompt history via Up/Down arrow |
| 16 | 2026-10-31 | `5600fc9` | fix(weibull): benchmarked probability paper — correct Y ln(ln) scale, compact β gauge |
| 17 | 2026-10-31 | `10a8c37` | doc: vscode config to use baseten meta muse spark as coding agent |
| 18 | 2026-10-31 | `4201174` | feat(chat): variable 3-line composer with mode dropdown, no scrollbar |
| 19 | 2026-10-31 | `21bf3a3` | ci: temporarily disable CI pipeline |
| 20 | 2026-10-31 | `cff791f` | feat(reliability): plan/ask modes, distribution selection, EDA plots, NIST KB [skip ci] |
| 21 | 2026-10-31 | `812a140` | fix(chat): keep meta-spark scaffolding out of streamed answers [skip ci] |
| 22 | 2026-10-31 | `eb802e0` | feat!: single Agent mode with context ledger and deterministic plots |
| 23 | 2026-11-01 | `7c303f3` | fix(frontend): close model picker menu on select |
| 24 | 2026-11-01 | `49e3c9d` | fix(weibull): restore y tick labels and title clearance on probability paper |
| 25 | 2026-11-01 | `d84864a` | feat(frontend): demo-ready hero, samples, and 16px type scale |
| 26 | 2026-11-01 | `85d6494` | docs: track 4.1.0 demo batch in hackathon provenance [skip ci] |
| 27 | 2026-11-01 | `5bf3dc2` | fix(weibull): keep every top artist outside the beta band |
| 28 | 2026-11-01 | `8156715` | docs: track 4.1.1 Weibull hardening in hackathon provenance [skip ci] |
| 29 | 2026-11-01 | `c705a63` | feat(frontend): KaTeX math rendering and plot lightbox |
| 30 | 2026-11-01 | `ed5ebc9` | docs: track 4.2.0 KaTeX and lightbox in hackathon provenance [skip ci] |
| 31 | 2026-11-01 | `9b8edab` | fix(scripts): no orphaned servers, real port guards, health-gated dev start |
| 32 | 2026-11-01 | `afdebd1` | docs: track 4.2.1 scripts fix in hackathon provenance [skip ci] |
| 33 | 2026-11-01 | `920b537` | Fix false no-data lecture, history evaporation, thinking flicker, B-life subscript [skip ci] |
| 34 | 2026-11-01 | `04b26a4` | feat!: single reliability domain, remove plan tools and domain switching [skip ci] |
| 35 | 2026-11-01 | `88ba69c` | fix: track parse_life_data_table in docs tool list and UI labels [skip ci] |
| 36 | 2026-11-01 | `f73c81a` | fix(chat): restore live streaming, exempt explanations from grounding guard [skip ci] |
| 37 | 2026-11-02 | `6fd27bf` | Optimize chat stream display (v5.0.2) |
| 38 | 2026-11-02 | `924cbdf` | Sync package-lock.json to v5.0.2 |
| 39 | 2026-11-02 | `6eb7815` | feat: meta hackathon video optimization — 5.1.0 [skip ci] |
| 40 | 2026-11-02 | `f8363f5` | chore: align Docker/docs to single reliability domain — remove mcp-physics overlay, Copilot naming [skip ci] |
| 41 | 2026-11-02 | `b3582f9` | docs: add docstrings + frontend comments — 5.1.1 [skip ci] |
| 42 | 2026-11-02 | `dacfa24` | docs: align README/ARCHITECTURE/SKILLS_INDEX to 5.1.1 build + Docker-first quick start [skip ci] |
| 43 | 2026-11-03 | `1a75c79` | chore: remove personal bio from knowledge base |
| 44 | 2026-11-03 | `2769c69` | fix(docker): make /app/backend writable by appuser so Settings can store API key |
| 45 | 2026-11-03 | `74486bd` | fix(docker): keep built UI visible under host static mount |
| 46 | 2026-11-03 | `6ad3188` | feat(frontend): remove warranty/B10 sample prompt from home screen |
| 47 | 2026-11-03 | `2385fc1` | feat(frontend): extend Weibull sample prompt dataset |
| 48 | 2026-11-03 | `5df36f0` | fix(frontend): correct sample prompt unit count to 9 |
| 49 | 2026-11-03 | `bbe5559` | docs: note Docker startup wait before health check |
| 50 | 2026-11-03 | `b1aac1f` | feat(reliability): add warranty forecast + demonstration test planning tools |
| 51 | 2026-11-03 | `ba9a67f` | feat(frontend): home chips showcase warranty forecast + demo-test planning |
