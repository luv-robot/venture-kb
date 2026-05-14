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
