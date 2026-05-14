#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/knowledge/venture-kb"

backup_if_exists() {
  local file="$1"
  if [ -f "$file" ]; then
    cp "$file" "$file.bak-$(date +%Y%m%d-%H%M%S)"
  fi
}

write_file() {
  local file="$1"
  local dir
  dir="$(dirname "$file")"
  mkdir -p "$dir"
  backup_if_exists "$file"
  cat > "$file"
  echo "[kb-batch] wrote $file"
}

write_file "10-projects/quant-odyssey/product-brief.md" <<'EOF'
---
type: project
project: quant-odyssey
status: active
updated: 2026-05-14
tags: [quant, agents, alpha-research, crypto, private-research, arena]
---

# QuantOdyssey Product Brief

## One-line Summary

QuantOdyssey is a private-first quant research and strategy evaluation platform for independent traders, technical operators, and AI-assisted researchers who want to discover, test, and protect trading ideas without surrendering alpha to a centralized platform.

## Core Thesis

The platform only becomes valuable if it solves a contradiction:

Users want tooling, validation, community, and possibly reputation, but they do not want to expose their alpha.

Therefore, QuantOdyssey should start as a private research and evaluation workspace, not as a public alpha-harvesting platform.

## Product Positioning

QuantOdyssey should be positioned as:

- Private quant research workspace
- Strategy review and evaluation system
- Optional anonymous proof-backed arena
- AI-assisted alpha discovery workflow
- Trust-minimized research infrastructure

It should not be positioned as:

- A generic trading bot
- A public leaderboard-first competition
- A WorldQuant-style alpha collection platform
- A platform requiring users to upload raw strategies
- A black-box “AI makes money” product

## Target Users

Primary users:

- Engineers exploring quant trading
- Product managers with technical execution ability
- Independent crypto traders
- Small quant research groups
- AI-assisted strategy builders
- Users skeptical of centralized alpha collection platforms

Secondary users:

- Strategy reviewers
- Arena participants
- Tool builders
- Data vendors
- Quant education communities

## User Psychology

A serious user may refuse to upload strategy code or raw alpha. The product must assume:

- Users are cautious about revealing strategies.
- Users may distrust public platforms.
- Users want validation without exposure.
- Some users are cautious even about ordinary hosted charting or backtesting tools.
- Strategy privacy is a first-class product requirement.

## Core Workflow

1. User researches in a private workspace.
2. User records hypotheses, market observations, data sources, and strategy specs.
3. Platform provides local or private evaluation tools.
4. User validates strategies privately.
5. User packages selected metrics or proof artifacts.
6. User optionally joins public or semi-public competitions.
7. User keeps raw alpha private unless voluntarily disclosed.

## Product Pillars

### Private Research Workspace

The workspace should support:

- Strategy notes
- Hypothesis records
- Backtest configs
- Evaluation reports
- Regime notes
- Data source references
- Versioned research artifacts
- Strategy review templates

### Private Evaluation

Evaluation should be possible without uploading raw strategy logic.

Important capabilities:

- Backtesting
- Walk-forward validation
- Monte Carlo stress testing
- Regime analysis
- Slippage and fee simulation
- Capacity estimation
- Overfit detection
- Future leak detection
- Result packaging

### Anonymous Metrics and Proofs

Users may share selected outputs:

- Return distribution
- Drawdown profile
- Trade frequency
- Market exposure
- Regime dependency
- Risk-adjusted metrics
- Capacity estimate
- Evaluation integrity proof

### ZKP Direction

Zero-knowledge proof or proof-like mechanisms are strategically important.

Long-term ideal:

- Users keep strategy code private.
- Public arena can verify results.
- Platform does not custody raw alpha.
- Evaluation integrity can be checked.

This is not necessarily an MVP feature, but it should shape the long-term design.

### Optional Public Arena

The arena should be opt-in.

Potential arena features:

- Anonymous leaderboards
- Risk-adjusted rankings
- Market-specific challenges
- Regime-specific challenges
- Proof-backed result submissions
- Strategy class competitions

The arena must not become an alpha extraction machine.

## Multi-Agent Research Platform Concept

The internal system may use layered agents.

### Command Layer

Responsible for orchestration and state.

Possible components:

- PM Agent
- Reviewer Agent
- n8n workflow
- Global state machine
- Approval flow
- Task routing

### Perception Layer

Responsible for market scanning.

Possible components:

- Market Scout
- News scanner
- Event scanner
- Funding monitor
- Open interest monitor
- Exchange data monitor
- Whale or wallet flow monitor
- Regime detector

### Strategy Layer

Responsible for research and hypothesis generation.

Possible components:

- Strategy Researcher
- Hypothesis generator
- Strategy spec writer
- Feature suggestion engine

### Backtest Layer

Responsible for evaluation.

Possible components:

- Backtest Specialist
- Freqtrade or custom backtest engine
- Walk-forward tester
- Monte Carlo evaluator
- Slippage simulator

### Risk Layer

Responsible for safety and audit.

Possible components:

- Risk Auditor
- Kill-switch logic
- Exposure limits
- Drawdown monitor
- Future leak detector
- Overfit detector

## Initial Technical Direction

Potential stack:

- Python-first
- Go for performance-sensitive modules
- Docker for deployment
- GitHub for versioning
- n8n for early orchestration
- Freqtrade as possible initial crypto engine
- Local or private evaluation workers
- Markdown-based research specs
- Future proof or attestation layer

## Strategy Themes

QuantOdyssey should support research around structural mistakes rather than naive indicator stacking.

Important strategy classes:

- Funding crowded reversal
- Trend exhaustion reversal
- Forced liquidation exhaustion
- Passive absorption after aggressive flow exhaustion
- High open interest unwind
- New coin volume spike shorting
- Event-driven volatility
- Pair trading
- Funding arbitrage
- Flash crash or wick capture

## Research Philosophy

Current beliefs:

- Simple RSI, MACD, Bollinger, golden cross, and death cross combinations are usually weak.
- Adding many filters may reduce trade frequency without enough edge improvement.
- K-line confirmation may be a poor proxy for microstructure.
- Tick trajectory, speed, order book behavior, funding, OI, and flow may contain more useful signal.
- Strategies should exploit other participants’ mistakes.
- Evaluation must distinguish luck, overfit, regime dependency, and structural edge.

## Evaluation Philosophy

The evaluation system should not unfairly penalize low-frequency, high-payoff strategies.

Important concerns:

- Monte Carlo baselines can misrepresent rare-event strategies.
- Optimizer-style backtests can overfit.
- Future leak must be aggressively prevented.
- Slippage and fee assumptions must be explicit.
- Regime dependency must be measured.
- Short-term reversal systems may fail in strong trends.
- Fat-tail strategies require special evaluation treatment.

## MVP Direction

The MVP should not start with a full public arena.

Safer sequence:

1. Private research knowledge base.
2. Strategy spec and review templates.
3. Evaluation pipeline for one or two strategy classes.
4. Standardized strategy review process.
5. Anonymous result package format.
6. Internal arena prototype.
7. Public arena only after privacy model is credible.

## Near-Term Deliverables

Useful next files:

- architecture.md
- workflow.md
- strategy-review-template.md
- funding-crowded-reversal.md
- private-evaluation-model.md
- arena-design-notes.md
- zkp-direction.md
- open-questions.md

## Current Working Assumptions

- Users are reluctant to share alpha.
- Private workspace should come before public arena.
- Proof direction is strategically important.
- Evaluation tools are valuable even without public competition.
- Codex can help build tooling when specs are clear.
- Hermes can maintain research memory.
- Obsidian and GitHub are the human-readable source of truth.
- Trust minimization is central to the product.

## Related Notes

- [[10-projects/quant-odyssey/open-questions]]
- [[30-decisions/2026-05-13-agent-tooling-roles]]
- [[30-decisions/2026-05-13-codex-spec-driven-development]]
EOF

write_file "10-projects/quant-odyssey/open-questions.md" <<'EOF'
---
type: question
project: quant-odyssey
status: active
updated: 2026-05-14
tags: [quant, open-questions, arena, privacy, zkp]
---

# QuantOdyssey Open Questions

## Product

- Is the first product a private research tool, a community, or a competition platform?
- Which user group has the strongest pain and willingness to pay?
- Should QuantOdyssey start local-first?
- What minimum privacy guarantee is needed for serious users to trust it?
- What result format is useful without exposing alpha?
- Should the product start with crypto only?

## Strategy

- Which strategy class should be the first review pipeline?
- Is funding crowded reversal measurable enough for MVP?
- Should the first market be BTC, ETH, major alts, or new listings?
- How should open interest be used as a scoring metric rather than an entry signal?
- What regime filters are necessary?
- How should the system evaluate low-frequency, fat-tail strategies?
- What is the right benchmark for event-driven and flash-crash strategies?

## Technical

- Should evaluation run locally, in user cloud, or on platform servers?
- Should Freqtrade be used first or should a custom engine be built?
- What data sources are mandatory for first strategy review?
- How can result integrity be verified without raw code upload?
- What is the minimal useful proof mechanism before real ZKP?
- How should future leak be prevented?

## Arena

- What should be ranked?
- Should rankings be based on live trading, paper trading, or sealed backtests?
- Should users submit code, signals, metrics, or proofs?
- How can leaderboard manipulation be prevented?
- How should latency fairness be handled?
- How can the arena avoid becoming an alpha extraction platform?

## Business

- Who pays first?
- Can the product charge for evaluation tooling?
- Can a community form before the arena exists?
- Is anonymous proof-backed reputation valuable enough?
- What services can be sold without touching user alpha?

## Related Notes

- [[10-projects/quant-odyssey/product-brief]]
EOF

write_file "10-projects/flashcutter/product-brief.md" <<'EOF'
---
type: project
project: flashcutter
status: active
updated: 2026-05-14
tags: [ai-video, ads, automation, mvp, codex]
---

# FlashCutter Product Brief

## One-line Summary

FlashCutter is an AI-assisted ad creative production system focused on programmable video editing, reusable ad templates, hooks, CTA clips, and narrow-scope AI-generated video assets.

## Core Problem

Short-form ad production requires many variants, but manual editing is slow and expensive. The user previously estimated human micro-tuning around RMB 0.5 per video and wants to explore automation toward a much lower unit cost.

## Product Direction

The product should combine:

- Template-based editing
- Programmatic video assembly
- Batch variant generation
- Reusable hooks and CTAs
- Reusable B-roll clips
- Narrow AI video generation
- Multi-user workflow
- Per-user billing for AI generation

## Target Users

- E-commerce sellers
- Small advertisers
- Content operators
- Agencies producing many ad variants
- Internal ad creative teams

## Important Constraints

- Full AI ad generation is too broad.
- AI-generated content must not look obviously AI if the market rejects that style.
- GPU cloud cost can easily destroy margins.
- Self-hosted servers may not fit the current cost model.
- MVP should avoid complex GUI automation unless necessary.
- Programmatic pipeline should be preferred over GUI bottlenecks.

## Narrow AI Generation Scope

AI generation should initially focus on:

1. Sample clips such as a reusable cat-talking scene.
2. Reusable B-roll primitives such as canned laughter or reaction clips.
3. Per-user hook and CTA clips.

AI generation should be separately billable.

## MVP Direction

The MVP should prioritize:

- Upload seed video
- Select template
- Configure output specs
- Generate variants
- Track job status
- Review outputs
- Collect rejection/performance feedback
- Improve template library

## Technical Direction

Likely stack:

- Python-first backend
- FFmpeg-based video processing
- Job queue for rendering
- Template JSON definitions
- Web dashboard
- Object storage if needed
- API integrations for selected AI video providers
- GitHub + Codex for implementation workflow

## Agent Workflow

Codex should implement scoped specs.

Hermes should maintain:

- Product memory
- Open questions
- Template design notes
- API vendor comparison notes
- Cost assumptions

## Current Working Assumptions

- Template-based assembly is the core.
- Narrow AI generation is an add-on.
- Multi-user support matters.
- Per-user billing is required for AI generation.
- MVP should avoid overbuilding collaboration features.
- Cost control is a central product constraint.

## Related Notes

- [[10-projects/flashcutter/open-questions]]
EOF

write_file "10-projects/flashcutter/open-questions.md" <<'EOF'
---
type: question
project: flashcutter
status: active
updated: 2026-05-14
tags: [flashcutter, ai-video, mvp, open-questions]
---

# FlashCutter Open Questions

## Product

- What is the narrowest useful MVP?
- Should MVP focus on template-based editing or AI-generated clips?
- Which user segment should be targeted first?
- Should the product start as an internal tool before becoming SaaS?
- What is the first paid feature?

## AI Video Generation

- Which AI video API should be integrated first?
- Should AI generation be limited to reusable clips?
- What cost threshold is acceptable per generated clip?
- Should generation be credit-based, per-render, or subscription-limited?
- How should user-specific hooks and CTAs be stored?

## Template System

- Should templates be JSON-based?
- How should template parameters be validated?
- Should templates be global, workspace-specific, or user-specific?
- How much customization should be allowed in MVP?
- How should rejected outputs feed back into templates?

## Video Pipeline

- Should the MVP use FFmpeg directly?
- What queue system is sufficient?
- Should uploaded assets be local first or object storage first?
- How should failed renders be retried?
- How should generated B-roll be cached?

## Business

- Can unit cost beat manual editing?
- What should be charged separately?
- How should multi-user billing work?
- How should rejection and performance feedback be monetized?

## Related Notes

- [[10-projects/flashcutter/product-brief]]
EOF

write_file "10-projects/game-analysis-ai/product-brief.md" <<'EOF'
---
type: project
project: game-analysis-ai
status: active
updated: 2026-05-14
tags: [games, ai, market-analysis, appstore, hypercasual]
---

# Game Analysis AI Product Brief

## One-line Summary

Game Analysis AI is a platform for scanning game distribution markets, identifying fast-growing casual or hyper-casual games, analyzing gameplay and monetization from an external user perspective, and producing actionable product planning documents.

## Core Thesis

There may be opportunity in building an AI-assisted black-box game analysis platform that studies games from the outside, without requiring developer-side analytics integration.

The product should focus on:

- Market discovery
- Gameplay analysis
- Ad and monetization structure
- Design decomposition
- Numeric model approximation
- Product planning output

## Target Games

Initial categories may include:

- Casual games
- Hyper-casual games
- Puzzle games
- Word games
- Runner games
- Match-3 games
- Light SLG
- Mini-program games

## Target Users

- Small game studios
- Product managers
- Game designers
- Publishers
- UA teams
- Indie developers
- Market researchers

## Core Workflow

1. Scan App Store, mini-program platforms, ad libraries, and rankings.
2. Detect high-growth games.
3. Collect store metadata, screenshots, videos, ads, and user reviews.
4. Analyze gameplay loop.
5. Analyze monetization points.
6. Estimate numerical model.
7. Generate planning document.
8. Feed output into development workflow.

## Product Direction

The product should not be a generic BI system requiring developer data integration.

It should be closer to:

- External game analyst
- Market scout
- Product teardown assistant
- Planning document generator
- Competitive intelligence workflow

## Key Challenge

Black-box analysis is hard because many internal metrics are unavailable.

The product should be honest about uncertainty and distinguish:

- Observed facts
- Inferred design logic
- Guessed numerical model
- Unsupported assumptions

## MVP Direction

The MVP should probably narrow to one or two categories first.

Possible first niches:

- Word games
- Runner games
- Match-3 games
- Simple casual games with visible monetization loops

## Current Working Assumptions

- Starting too broad will create low-quality analysis.
- Category-specific models may be necessary.
- External user-perspective analysis is the differentiator.
- The output should be useful to product planning, not just reporting.
- Human review may be needed before generated plans become trustworthy.

## Related Notes

- [[10-projects/game-analysis-ai/open-questions]]
EOF

write_file "10-projects/game-analysis-ai/open-questions.md" <<'EOF'
---
type: question
project: game-analysis-ai
status: active
updated: 2026-05-14
tags: [games, ai, open-questions]
---

# Game Analysis AI Open Questions

## Product Scope

- Which game category should be analyzed first?
- Is black-box analysis strong enough without developer telemetry?
- What output format is most valuable to studios?
- Should the product focus on discovery, teardown, or planning generation first?

## Data Sources

- Which app stores and mini-program platforms should be scanned?
- Which ad libraries are accessible?
- Can gameplay videos be collected legally and reliably?
- How should user reviews be summarized?
- What ranking and growth signals are reliable?

## Analysis

- Can AI infer gameplay loops accurately from video and screenshots?
- How accurate can monetization analysis be from outside?
- How should uncertainty be represented?
- Can approximate numeric models be useful without telemetry?

## MVP

- Should MVP focus on one genre?
- Which genre gives the cleanest visible mechanics?
- What is the smallest useful report?
- Can a human analyst use AI-generated teardown as a draft?

## Business

- Who pays for this?
- Studios, publishers, investors, or UA teams?
- Is this a SaaS, report service, or internal tool?
- Can low-cost market intelligence beat expensive ASO tools?

## Related Notes

- [[10-projects/game-analysis-ai/product-brief]]
EOF

write_file "10-projects/twlr/product-brief.md" <<'EOF'
---
type: project
project: twlr
status: active
updated: 2026-05-14
tags: [writing, novels, agents, story-graph, creator-tools]
---

# TWLR Product Brief

## One-line Summary

TWLR, The Writer’s Living Room, is a multi-agent creative studio for serious writers that aims to provide high-quality editorial, market, and reader-perspective support rather than generic AI co-writing.

## Core Thesis

AI cannot yet reliably write excellent novels by itself. That limitation creates product opportunity.

The product should not compete as a simple one-click writing generator. It should provide a heavier studio experience built on:

- Data
- Distribution insight
- Feedback loops
- Story structure knowledge
- Curated agents
- Long-term creative memory

## Product Positioning

TWLR should be a “living room” where writers return when they are stuck, anxious, or uncertain.

The goal is:

When creators panic or get stuck, they want to enter the living room and talk to a serious teacher or editor.

## Target Users

- Web novel writers
- Short drama writers
- Genre fiction creators
- Serious amateur writers
- Commercial fiction creators
- Possibly academic writers in a later branch

## Agent Concept

Built-in agents may include:

- Assistant agent
- Market analysis consultant
- Strict editor
- Genre superfan personas
- Reader personas
- Structure advisor
- Plot doctor

The platform should avoid arbitrary user-defined agents at first, because that may reduce coherence and quality.

## Editor Scope

The manuscript editor should exist, but it should be lightweight.

It is not the moat.

The stronger moat is:

- Agent quality
- Knowledge extraction
- Market feedback loop
- Story graph
- Long-term creative memory
- Interpretation of genre structure and reader behavior

## Story Graph Direction

A story graph may capture:

- Timeline
- Character arcs
- Emotional structure
- Conflict structure
- Plot beats
- Reader expectation
- Foreshadowing
- Payoff
- Genre conventions

Long-term ambition:

Map interpretable story emotion structure to reader behavior.

## Product Constraints

- Full collaborative editing may be a large pit.
- Version control may be a large pit.
- Mobile should not attempt full feature parity.
- Local/private feeling matters because creators care about IP.
- The product must avoid feeling like generic prompt engineering.

## Mobile Scope

Mobile version may support:

- Idea card capture
- Outline tweaks
- Character notes
- Agent meetings
- Quick feedback

It should not try to be a full manuscript editor.

## Current Working Assumptions

- Serious creators are a small but potentially high-value market.
- The product should help before and during writing, not just generate text.
- Market and reader feedback loops are part of the moat.
- A lightweight editor is useful for context, but not the core scarcity.
- Public curated agents are better than arbitrary user agents at first.

## Related Notes

- [[10-projects/twlr/open-questions]]
EOF

write_file "10-projects/twlr/open-questions.md" <<'EOF'
---
type: question
project: twlr
status: active
updated: 2026-05-14
tags: [twlr, writing, open-questions]
---

# TWLR Open Questions

## Product

- What is the first narrow use case?
- Should TWLR start with web novels, short drama, or serious fiction?
- What is the strongest “panic moment” that drives usage?
- How much manuscript editor is necessary?
- Should the editor be local-first or cloud-first?

## Agents

- Which agents should be built first?
- What makes an editor agent truly better than prompt engineering?
- How should agent memory be structured?
- Should agents have curated personalities?
- How should fan personas be grounded?

## Data

- What market data is available?
- How can typical works be decomposed?
- Can genre structures be extracted at scale?
- How can reader feedback be mapped to story structure?
- What data creates defensibility?

## Story Graph

- What should be represented in the graph?
- Is graph database necessary at MVP?
- Can the story graph be useful before advanced modeling?
- How should emotional arcs be represented?

## Business

- Are serious creators willing to pay enough?
- Is this too niche?
- Can TWLR expand into academic writing later?
- What features are not covered well by Scrivener or Overleaf?

## Related Notes

- [[10-projects/twlr/product-brief]]
EOF

write_file "10-projects/ai-coach/product-brief.md" <<'EOF'
---
type: project
project: ai-coach
status: active
updated: 2026-05-14
tags: [education, coaching, trading, k12, personalized-learning]
---

# AI Coach Product Brief

## One-line Summary

AI Coach is a personalized training and practice system that can start with prop-firm trading exam preparation and later generalize to other knowledge domains such as K12, CPA, legal exams, or sports training.

## Initial Use Case

The initial concrete use case is a personal coach app to help pass a prop firm investment exam within roughly 90 days.

Markets:

- US equity futures
- Mainstream crypto

Trading timeframes:

- 5 minutes
- 15 minutes
- 1 hour

Strategies to learn:

- Trend
- Reversal
- Scalping

## Core Product Idea

The coach should provide:

- Structured curriculum
- Simulation practice
- Historical market replay
- Special period challenges
- Mistake tracking
- Personalized review
- Weakness diagnosis
- Training plan updates

## Special Period Challenges

The simulator should include scenarios such as:

- News-driven crashes
- Low-liquidity periods
- Squeezes
- Stop-hunt dynamics
- High volatility regimes
- Trend exhaustion
- Failed breakout
- Forced liquidation events

## Generalization Thesis

If the workflow works for trading, it may generalize to:

- K12 tutoring
- CPA exam preparation
- Legal exams
- Sports skill coaching
- Other structured learning tasks

The common pattern:

1. Diagnose current ability.
2. Track repeated mistakes.
3. Infer missing prerequisite knowledge.
4. Assign targeted practice.
5. Update the user model.
6. Repeat over time.

## Memory Requirement

A serious coach likely needs stronger memory than a simple chat interface.

It should remember:

- User goals
- Current level
- Repeated error patterns
- Weak concepts
- Completed practice
- Response to previous interventions
- Emotional and motivation patterns where appropriate

## Technical Direction

Potential components:

- User model
- Skill graph
- Practice generator
- Mistake classifier
- Prerequisite diagnosis
- Review scheduler
- Simulation engine
- Long-term memory store
- Coach conversation interface

## Current Working Assumptions

- Prompt engineering alone may not be enough.
- The system needs structured memory and state.
- The coach should know when to call diagnostic routines.
- For K12, repeated mistakes should trigger prerequisite checks.
- Trading knowledge may be shorter than other domains, but market competition makes practice difficult.
- Personalization is central to product quality.

## Related Notes

- [[10-projects/ai-coach/open-questions]]
EOF

write_file "10-projects/ai-coach/open-questions.md" <<'EOF'
---
type: question
project: ai-coach
status: active
updated: 2026-05-14
tags: [ai-coach, education, trading, open-questions]
---

# AI Coach Open Questions

## Initial Trading Coach

- What is the smallest useful training loop for prop-firm preparation?
- Which market should be supported first?
- What historical data is needed?
- How should special periods be selected?
- How should trading mistakes be classified?
- Should the coach teach strategies or mainly supervise practice?

## Personalization

- What should the user model store?
- How should repeated errors trigger diagnosis?
- How should the coach infer missing prerequisite knowledge?
- When should the coach ask probing questions?
- How should progress be measured?

## Generalization

- Can the same workflow generalize to K12?
- What changes for CPA or legal exams?
- Is a domain-specific skill graph required?
- How expensive is high-quality domain modeling?
- Can a general coaching engine support many subjects?

## Technical

- What memory architecture is needed?
- Is vector memory enough?
- Is a relational skill model required?
- Should Hermes-like local storage be adapted?
- How should multi-device sync work?
- Should the coach be an app, agent, or web service?

## Business

- Which domain has the best willingness to pay?
- Is trading coach too competitive or risky?
- Is K12 too high-stakes?
- Can the product start as a personal tool?
- What evidence is needed before productizing?

## Related Notes

- [[10-projects/ai-coach/product-brief]]
EOF

if command -v kb >/dev/null 2>&1; then
  kb index
else
  "$HOME/knowledge/venture-kb/scripts/kb.sh" index
fi

git add .
if git diff --cached --quiet; then
  echo "[kb-batch] nothing to commit."
else
  git commit -m "Add initial project knowledge base notes"
fi

git push

echo "[kb-batch] done."
