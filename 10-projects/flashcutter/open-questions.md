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
