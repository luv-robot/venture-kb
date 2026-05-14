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
