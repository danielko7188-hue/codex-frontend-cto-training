# Design Memory

This is the shared UX/UI memory system for Codex across all your projects.

Its job is simple:

- remember what premium looks like for you
- remember what generic looks like for you
- study the best open-source UI systems without mistaking code quality for visual taste
- store reusable design lessons
- make future frontend work better without requiring screenshot hand-holding

## Structure

- [reference-bank](./reference-bank/README.md)
- [source-library](./source-library/README.md)
- [review-pipeline](./review-pipeline)
- [ai-product-ux-playbook](./playbooks/AI_PRODUCT_UX_PLAYBOOK.md)
- [project-reviews](./project-reviews)
- [playbooks](./playbooks)
- [templates](./templates)
- [tools](./tools)
- [manifests](./manifests)
- [harvested](./harvested)

## How this gets used

1. Codex inspects a real project.
2. Codex runs the app and captures its own screenshots.
3. Codex audits the UI using the review pipeline.
4. Codex redesigns and verifies the result.
5. Codex saves lessons that are likely to matter again.

## What belongs here

- references you love
- references you dislike
- neutral references that are useful but not taste-defining
- curated source-code systems that teach component architecture, accessibility, theming, and AI UI patterns
- reusable AI product UX guidance for chat, copilot, workflow, and agent surfaces
- project-specific review notes
- reusable frontend playbooks

## What does not belong here

- giant random template dumps
- unstructured screenshots with no explanation
- one-off opinions with no design lesson
- copied proprietary source code from reference sites

## Two different training lanes

- [reference-bank](C:/Users/wsk71.DKO/Desktop/Frontend%20Developer/design-memory/reference-bank) is for visual judgment, product taste, section pacing, proof, hierarchy, and what feels premium or generic.
- [source-library](C:/Users/wsk71.DKO/Desktop/Frontend%20Developer/design-memory/source-library) is for code-system learning: accessible primitives, tokens, component APIs, theming, app shells, AI chat layouts, forms, and data display.

Use both. Do not confuse them.

- A great screenshot can sharpen taste but teach very little implementation discipline.
- A great component repo can sharpen implementation discipline but still not give a complete visual direction.

## Core rule

Every entry should answer at least one of these:

- Why does this feel premium?
- Why does this feel generic?
- What should we borrow?
- What should we avoid?
- In what product context does this work?

## Current starter set

- [CURATED_SET_2026-04-07.md](./reference-bank/CURATED_SET_2026-04-07.md)
- [CURATED_CODE_SET_2026-04-07.md](./source-library/CURATED_CODE_SET_2026-04-07.md)
