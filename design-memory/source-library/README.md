# Source Library

This is the code-learning side of the frontend training system.

Its job is to help Codex learn from strong open-source UI systems and product-grade frontend repos without pretending that code alone equals good taste.

## What belongs here

- official docs for strong UI systems
- maintained open-source component libraries
- product-grade example apps
- AI interface repos that teach chat, tool-call, and workspace patterns
- notes on what each source teaches well

## What this is for

- accessible primitives
- component composition
- tokens and theming
- forms, tables, drawers, dialogs, and app shells
- information density and enterprise clarity
- AI chat and agent workspace patterns

## What this is not for

- copying somebody else's product
- cloning a brand look pixel-for-pixel
- replacing the visual [reference-bank](../reference-bank/README.md)
- dumping random repos with no lesson attached

## Core rule

Every entry should answer:

- What skill can we learn from this codebase?
- What part of frontend craft does it teach well?
- What should we inspect first?
- What should we avoid copying too literally?

## Buckets

- [foundations](./foundations)
- [systems](./systems)
- [ai-interfaces](./ai-interfaces)
- [templates](./templates)
- [design-md-packs](./design-md-packs)
- `clones/` is an optional local cache and is intentionally excluded from this public repo

## Current curated set

- [CURATED_CODE_SET_2026-04-07.md](./CURATED_CODE_SET_2026-04-07.md)
- [TEMPLATE_PACK_2026-04-07.md](./TEMPLATE_PACK_2026-04-07.md)
- [DESIGN_MD_PACKS_2026-04-07.md](./DESIGN_MD_PACKS_2026-04-07.md)
- [AI_PRODUCT_UX_PACK_2026-04-07.md](./AI_PRODUCT_UX_PACK_2026-04-07.md)

## Ingestion workflow

1. Update the manifest in [manifests](../manifests).
2. Run the ingestion script in [tools](../tools).
3. Generate or refresh the markdown entries in the right bucket.
4. Optionally shallow-clone the repos into `clones/` in a local workspace.
5. Study the right source for the job instead of reading everything.

## Study rule

Do not try to ingest every file in every repo.

Start with the parts that usually teach the most:

- core primitives
- theme or token setup
- form components
- data display components
- examples or templates
- AI chat or message rendering surfaces
- DESIGN.md packs when you need an agent-readable style system derived from strong products

When a new product needs a strong starting structure, inspect the `templates` bucket before improvising the page or app shell from scratch.
