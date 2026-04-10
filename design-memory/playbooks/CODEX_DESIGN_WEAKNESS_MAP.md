# Codex Design Weakness Map

This file is the blunt list of where Codex is still weak in UX/UI work.

Its purpose is not to criticize. Its purpose is to stop repeating the same design mistakes.

## Core Weaknesses

### 1. Safe-but-generic composition

Typical failure:

- too many cards
- too many rounded boxes
- too much even spacing
- too little visual tension
- everything feels "clean" but nothing feels memorable

Why this happens:

- Codex often optimizes for local correctness instead of strong art direction
- repeated component patterns feel safe in code, so they get overused

How to correct it:

- choose one strong section to dominate the page
- reduce box count before adding polish
- ask "what is the one thing the eye should land on first?"
- remove any section that feels interchangeable with a template

### 2. Weak design thesis before coding

Typical failure:

- starts implementing too early
- improves the old layout instead of choosing a better direction
- builds a competent version of the wrong idea

Why this happens:

- code is easier to act on than visual ambiguity

How to correct it:

- decide the design lane before implementation
- write one sentence describing the page's visual thesis
- define one "must feel like" and one "must not feel like"

### 3. Flat hierarchy

Typical failure:

- too many sections have similar weight
- headings are fine but not forceful
- proof is present but not prioritized
- CTAs exist but do not feel inevitable

Why this happens:

- Codex spreads attention too evenly

How to correct it:

- pick a clear order: promise, proof, process, objection handling, CTA
- increase contrast between primary and secondary elements
- make at least one proof block feel unmistakably important

### 4. Premium confused with bland

Typical failure:

- restrained but emotionally flat
- polished but not distinctive
- expensive-looking in theory, forgettable in practice

Why this happens:

- Codex often removes noise without adding conviction

How to correct it:

- use fewer elements, but make them stronger
- sharpen typography before adding decoration
- use one purposeful visual motif, not many weak ones

### 5. Over-boxing

Typical failure:

- every idea lives in a card
- interfaces look assembled from component demos
- pages feel modular but not authored

Why this happens:

- component-driven thinking takes over page-level thinking

How to correct it:

- use open layouts more often
- reserve cards for actual grouping, proof, or interaction
- let typography and spacing carry structure where possible

### 6. Mobile as adaptation, not first-class design

Typical failure:

- desktop concept looks reasonable
- mobile becomes tall, padded, and box-heavy
- image and proof blocks create dead space

Why this happens:

- desktop composition gets decided first
- mobile only gets compressed after the fact

How to correct it:

- audit mobile screenshots before calling any page done
- simplify section stacking on small screens
- avoid tall decorative image shells on mobile unless they earn their space

### 7. Product-flow thinking weaker than surface polish

Typical failure:

- UI looks more polished than the actual user journey
- pages look organized but the next step is still unclear
- AI tools look impressive but user control is weak

Why this happens:

- screen-level design is easier than workflow-level design

How to correct it:

- map the user decision path first
- ask what users need to know, decide, edit, approve, or trust at each step
- prefer flow clarity over visual cleverness

### 8. Narrow style range

Typical failure:

- too often defaults to calm premium SaaS
- struggles to pivot into editorial, industrial, warm-service, or bold-launch modes

Why this happens:

- the current training system is strongest in minimalist premium references

How to correct it:

- choose a style lane from the style spectrum before design work
- state which lane is primary and which lane is supporting
- explicitly name one lane to avoid

## Failure Signs

Stop and rework if any of these are true:

- "This looks fine" is the best compliment available
- the whole page could belong to almost any startup
- every section has the same visual weight
- there are too many bordered boxes
- the product value is not obvious in the first screen
- the mobile version feels longer, softer, or more padded than the desktop
- the founder says it looks generic, safe, or AI-generated

## Training Rules

Before major design work:

1. Pick a style lane from [STYLE_SPECTRUM_2026-04-07.md](../source-library/STYLE_SPECTRUM_2026-04-07.md).
2. Write the one-sentence design thesis.
3. Name one anti-pattern most likely to appear in the current project.

After major design work:

1. Grade the result with the scorecard.
2. Check this weakness map and note which failure mode appeared.
3. Check [FAILURE_PATTERN_PACK_2026-04-07.md](../source-library/FAILURE_PATTERN_PACK_2026-04-07.md) and name the matching failure patterns.
4. Save one reusable lesson into project memory.

## Goal

The goal is not just "nicer UI."

The goal is for Codex to stop producing safe, boxy, generic work and become more intentional, flexible, and convincing across different product types.
