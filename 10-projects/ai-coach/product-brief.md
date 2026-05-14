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
