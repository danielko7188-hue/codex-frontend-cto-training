# Design Direction Selector

Use this before major frontend redesign work.

Its job is to force a clear design choice before coding starts.

## Step 1: Pick The Main Lane

Choose one primary lane from [STYLE_SPECTRUM_2026-04-07.md](../source-library/STYLE_SPECTRUM_2026-04-07.md).

Examples:

- `minimalist-premium`
- `enterprise-trust`
- `editorial-luxury`
- `technical-industrial`
- `warm-service`
- `bold-launch`
- `calm-ai-workspace`
- `operator-density`

## Step 2: Pick The Support Lane

Choose one support lane only if it helps.

Examples:

- `enterprise-trust` with `technical-industrial`
- `minimalist-premium` with `editorial-luxury`
- `calm-ai-workspace` with `operator-density`

Do not blend three or four directions. That usually creates muddy design.

## Step 3: Pick An Anti-Lane

Name one lane the project must avoid.

Examples:

- `warm-service` but avoid `bold-launch`
- `technical-industrial` but avoid `editorial-luxury`
- `minimalist-premium` but avoid `generic-saas-template`

## Step 4: Write The Thesis

Write one sentence:

- "This should feel like ..."

Then write one more:

- "This must not feel like ..."

Examples:

- "This should feel like a serious export operator, not a startup landing page."
- "This should feel like an AI workspace for operators, not a chat toy."

## Step 5: Lock The Visual System

Before coding, decide:

- type mood
- surface language
- spacing cadence
- image strategy
- proof strategy
- CTA behavior

## Step 6: Audit Against The Weakness Map

Read [CODEX_DESIGN_WEAKNESS_MAP.md](./CODEX_DESIGN_WEAKNESS_MAP.md) and explicitly check:

- safe composition
- flat hierarchy
- over-boxing
- weak mobile translation
- narrow style range

## Quick Template

Use this block in notes before implementation:

```md
Primary lane:
Support lane:
Anti-lane:

This should feel like:
This must not feel like:

Primary CTA:
Main proof:
Most likely failure mode:
```
