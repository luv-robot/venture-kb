---
type: project
project: quant-odyssey
status: active
updated: 2026-05-13
tags:
  - quant
  - agents
  - alpha-research
  - private-research
  - crypto
  - arena
---

# QuantOdyssey Product Brief

## One-line Summary

QuantOdyssey is a private-first quant research and strategy evaluation platform for independent traders, product-minded engineers, and AI-assisted researchers who want to discover, test, and protect trading ideas without surrendering alpha to a centralized platform.

## Core Thesis

The value of QuantOdyssey depends on whether AI creates a new class of displaced or underemployed product managers, engineers, and technical operators who are capable of researching markets but do not want to hand their best alpha to platforms such as WorldQuant.

The platform should not assume users are willing to upload raw strategies or disclose alpha. The default product posture should be private research first, public competition second.

## Target Users

Primary users:

- Experienced engineers exploring quant trading
- Product managers with technical execution ability
- Independent crypto traders
- Small quant research groups
- AI-assisted strategy builders
- People who distrust centralized alpha collection platforms

Secondary users:

- Arena participants
- Strategy reviewers
- Tool builders
- Data vendors
- Education-oriented quant communities

## User Psychology

A key assumption is that serious users do not want to give away their alpha.

Observed user behavior:

- They may refuse to publish strategies.
- They may refuse to upload raw code.
- They may avoid platforms that can observe their research.
- Some users are cautious even about using TradingView.
- They want tools, validation, and community, but not at the cost of exposing strategy logic.

Therefore, QuantOdyssey should avoid looking like a platform that extracts alpha from users.

## Product Positioning

QuantOdyssey should be positioned as:

A private quant research workspace with optional anonymous proof and optional public arena participation.

Not as:

- A marketplace that collects user strategies
- A WorldQuant-style alpha harvesting platform
- A public leaderboard-first competition platform
- A black-box AI trading bot
- A generic backtesting website

## Core Workflow

The desired flow is:

1. User researches in their own private workspace.
2. Platform provides local or private evaluation tools.
3. User validates strategy performance privately.
4. User may upload anonymous metrics or proofs.
5. User may choose whether to participate in a public arena.
6. User keeps strategy logic private unless they voluntarily disclose it.

## Product Pillars

### 1. Private Research Workspace

Users should be able to research, test, and iterate on strategies without exposing raw alpha.

The private workspace should support:

- Strategy notes
- Backtest configs
- Data references
- Evaluation results
- Local or private execution
- Versioned research artifacts

### 2. Local or Private Evaluation

The platform should provide evaluation tools that can run locally or in a private environment.

The goal is to allow users to prove strategy quality without uploading raw strategy logic.

Important capabilities:

- Backtesting
- Walk-forward validation
- Monte Carlo stress testing
- Regime analysis
- Slippage and fee simulation
- Robustness checks
- Result packaging

### 3. Anonymous Metrics and Proofs

Users should be able to share selected performance summaries without disclosing strategy internals.

Possible shared outputs:

- Return distribution
- Drawdown profile
- Trade frequency
- Market exposure
- Regime dependency
- Capacity estimate
- Risk-adjusted metrics
- Proof of evaluation integrity

### 4. Zero-Knowledge Proof Direction

Zero-knowledge proof is strategically important.

The long-term ideal is:

- Users keep strategy logic private.
- Evaluation can be verified.
- Public arena can trust results without receiving raw alpha.
- Platform does not need to custody strategy code.

This is not necessarily an MVP feature, but it should be included in the long-term architecture direction.

### 5. Optional Public Arena

The arena should be opt-in.

The public arena may support:

- Strategy contests
- Anonymous leaderboards
- Risk-adjusted ranking
- Time-window challenges
- Market-specific competitions
- Proof-backed submissions

The arena should not require users to reveal raw strategy code.

## Strategic Value

QuantOdyssey becomes valuable if it solves this contradiction:

Users want recognition, validation, tooling, and possibly monetization, but they do not want to surrender alpha.

The platform must therefore provide:

- Trust
- Privacy
- Local control
- Evaluation credibility
- Optional public participation
- Strong anti-extraction positioning

## Multi-Agent Platform Concept

A possible internal architecture uses multiple specialized agents and systems.

Suggested layers:

### Command Layer

Orchestration and project state.

Possible components:

- PM Agent
- Reviewer Agent
- n8n workflow
- Global state machine
- Task routing
- Approval flow

### Perception Layer

Market scanning and opportunity discovery.

Possible components:

- Market Scout
- News and event scanner
- Funding and open interest monitor
- Exchange data monitor
- Whale or wallet flow monitor
- Regime detector

### Strategy Layer

Strategy research and hypothesis generation.

Possible components:

- Strategy Researcher
- Hypothesis generator
- Strategy specification writer
- Feature suggestion engine

### Execution and Backtest Layer

Strategy evaluation and simulation.

Possible components:

- Backtest Specialist
- Freqtrade or custom backtest engine
- Walk-forward tester
- Monte Carlo evaluator
- Slippage simulator

### Risk Layer

Risk control and audit.

Possible components:

- Risk Auditor
- Kill-switch logic
- Exposure limits
- Drawdown monitor
- Overfit detector
- Future leak detector

## Initial Technical Direction

Potential stack:

- Python-first
- Go as secondary language for performance-sensitive modules
- Docker for deployment
- GitHub for code collaboration
- n8n for early orchestration
- Freqtrade as possible crypto strategy execution and backtesting base
- Local or private evaluation workers
- Markdown-based specs and research notes
- Future support for proof or attestation layer

## Important Strategy Themes

The platform should support research around strategies that exploit structural market mistakes rather than generic indicator stacking.

Examples:

- Funding crowded reversal
- Trend exhaustion reversal
- Forced liquidation exhaustion
- Passive absorption after aggressive flow exhaustion
- High open interest risk unwind
- New coin volume spike shorting
- Event-driven volatility
- Pair trading
- Funding arbitrage
- Flash crash or wick capture

## Funding Crowded Reversal Strategy

A previously discussed strategy theme:

Market observation:

Crowded funding environments can create one-sided positioning. When the market becomes overleveraged in one direction, a reversal can happen if price fails to continue and forced exit pressure emerges.

Hypothesis:

When funding, open interest, price extension, and local market structure indicate crowded leverage, the probability of reversal increases if the continuation move fails.

Trading logic:

- Detect elevated funding or crowded directional exposure.
- Confirm that price is near a meaningful coordinate, such as a recent extreme or round number.
- Watch for failure to continue.
- Look for signs of aggressive flow exhaustion.
- Enter after recapture or reversal confirmation.
- Use strict invalidation if price resumes trend with strength.

Important constraint:

Open interest is primarily a scoring metric, not a direct entry signal.

## Quant Research Philosophy

The platform should avoid naive indicator stacking.

Current beliefs:

- Simple RSI, MACD, Bollinger, golden cross, and death cross combinations are often weak.
- Adding many filters may reduce trade frequency without improving edge enough.
- K-line confirmation may be a poor proxy for true microstructure.
- Tick trajectory, speed, order book behavior, open interest, funding, and flow may contain more useful signal.
- Low-level data may be more valuable than human-visual indicators.
- Strategies should be evaluated against regime, cost, capacity, and tail risk.

## Evaluation Philosophy

The evaluation system should avoid unfairly penalizing low-frequency, high-return, fat-tail strategies.

Important concerns:

- Monte Carlo baselines may misrepresent strategies with rare but large payoff events.
- Optimizer-style backtests can overfit.
- Future leak must be aggressively prevented.
- Strategy performance should be tested across regimes.
- Slippage and fee assumptions must be explicit.
- Strong trend regimes may break short-term reversal strategies.
- Evaluation should distinguish luck, overfit, regime dependence, and structural edge.

## Arena Design Concerns

If QuantOdyssey includes a public arena, it must handle:

- Latency fairness
- Data feed fairness
- Future leak prevention
- Delayed feed risks
- Strategy privacy
- Proof of result integrity
- Leaderboard manipulation
- Overfitting to competition windows
- Whether scripts, DSLs, or containerized strategies are supported

The arena should not become a mechanism for extracting user alpha.

## Community Strategy

A community may form around:

- Private research tooling
- Strategy evaluation standards
- Anonymous proof-backed competitions
- Educational reviews
- Research templates
- Market regime discussions

The community should avoid encouraging users to reveal raw alpha too early.

## MVP Direction

The MVP should probably not start with full public arena.

A safer MVP sequence:

1. Private knowledge base and research workflow.
2. Local strategy spec and evaluation template.
3. Backtest and review pipeline for one or two strategy classes.
4. Standardized strategy review process.
5. Anonymous result package format.
6. Optional internal arena prototype.
7. Public arena only after privacy and trust model is clear.

## Near-Term Deliverables

Useful next documents:

- architecture.md
- workflow.md
- strategy-review-template.md
- funding-crowded-reversal.md
- private-evaluation-model.md
- arena-design-notes.md
- zkp-direction.md
- open-questions.md

## Open Questions

Product questions:

- Is the first product a private tool, community, or competition platform?
- Which user group has the strongest pain and willingness to pay?
- Should QuantOdyssey start as a local-first tool?
- How much privacy is required for users to trust the platform?
- What result format is useful without exposing alpha?

Technical questions:

- Should evaluation run locally, in user cloud, or on platform servers?
- How can result integrity be verified without raw code upload?
- What is the minimal useful proof mechanism before real ZKP?
- What data sources are required for the first strategy class?
- Should the system use Freqtrade first or a custom backtest engine?

Strategy questions:

- Which strategy class is best for the first review pipeline?
- Is funding crowded reversal sufficiently measurable?
- Which market should be used first: BTC, ETH, major alts, or new listings?
- How should open interest be used as a scoring metric?
- What regime filters are necessary?

Arena questions:

- What should be ranked?
- Should rankings be based on live trading, paper trading, or sealed backtests?
- How can future leak be prevented?
- Should users submit strategy code, signals, metrics, or proofs?
- What incentives prevent alpha extraction fear?

## Current Working Assumptions

- Users are reluctant to share alpha.
- Private workspace should come before public arena.
- ZKP or proof direction is strategically important.
- Evaluation tools are valuable even without public competition.
- Codex can help build tooling when specs are clear.
- Hermes can help maintain research memory.
- Obsidian and GitHub should serve as the human-readable knowledge base.
- The platform should be designed around trust minimization.

## Related Notes

- [[30-decisions/2026-05-13-agent-tooling-roles]]
- [[30-decisions/2026-05-13-codex-spec-driven-development]]
- [[20-playbooks/hermes-agent]]
