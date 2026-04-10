# Failure Pattern Pack 2026-04-07

This file maps recurring bad UX/UI outcomes to the warning signs that reveal them and the corrections that usually fix them.

Its purpose is prevention.

The reference packs teach what good can look like.

This pack teaches what bad looks like before it ships.

Use it during audits, mid-implementation checks, and final visual QA.

## Card Soup

- What it looks like: too many bordered boxes, every idea gets its own card, weak page authorship
- Why it happens: component-driven thinking replaces page-level hierarchy
- Warning signs:
  - more than three adjacent cards with equal weight
  - cards used for copy that could be plain layout and type
  - the page looks like a component gallery
- Corrective moves:
  - remove the weakest cards first
  - let typography and spacing create structure
  - make one dominant block, not five equal blocks

## Empty Premium Hero

- What it looks like: large type, soft gradients, little proof, little specificity
- Why it happens: premium styling gets used to hide weak messaging
- Warning signs:
  - hero could fit almost any startup
  - no concrete proof or example appears above the fold
  - the CTA asks for commitment before trust is earned
- Corrective moves:
  - add one concrete proof move in the first screen
  - reduce abstract copy
  - show the product, process, or outcome immediately

## Weak CTA

- What it looks like: buttons exist but no action feels inevitable
- Why it happens: too many competing actions or weak action language
- Warning signs:
  - more than one primary-looking button
  - CTA labels like "Learn more" or "Get started" with no context
  - the page never tells the user what happens next
- Corrective moves:
  - choose one dominant action per section
  - rewrite CTA text to describe the next step
  - place trust or proof near the action

## Flat Hierarchy

- What it looks like: everything is clear enough, nothing is important enough
- Why it happens: spacing, type scale, and contrast are too evenly distributed
- Warning signs:
  - every section feels similar in weight
  - proof and CTA do not stand out from the rest
  - the eye has no obvious landing point
- Corrective moves:
  - rank the page: promise, proof, process, objection handling, CTA
  - increase contrast between major and minor content
  - make one proof block unmistakably important

## Bland Premium

- What it looks like: calm, polished, forgettable
- Why it happens: noise gets removed without replacing it with conviction
- Warning signs:
  - "looks nice" is the strongest available reaction
  - no section has a memorable visual idea
  - typography is correct but not forceful
- Corrective moves:
  - sharpen the main headline and supporting proof
  - add one stronger visual motif or asymmetric move
  - make the page feel authored, not merely cleaned up

## Mobile Dead Space

- What it looks like: stacked boxes, tall image shells, long padded sections, sleepy mobile rhythm
- Why it happens: desktop layout is compressed instead of redesigned for mobile
- Warning signs:
  - mobile feels softer and longer than desktop
  - decorative media consumes key vertical space
  - forms and proof blocks require too much scrolling
- Corrective moves:
  - collapse ornamental wrappers
  - shorten section padding on small screens
  - reorder the mobile stack around the user's next decision

## Trustless Conversion

- What it looks like: asks for money, time, or contact info before credibility is established
- Why it happens: conversion mechanics are added before objection handling
- Warning signs:
  - forms appear before proof
  - quote/demo CTAs appear with no guarantee, review, or result nearby
  - the page sounds sales-y but not grounded
- Corrective moves:
  - move proof higher
  - add named customers, reviews, guarantees, or concrete outcomes
  - reduce the ask until trust is earned

## Dashboard Marketing Bleed

- What it looks like: product UI uses marketing-site spacing, giant cards, and decorative emptiness
- Why it happens: marketing aesthetics get pasted into task-heavy product screens
- Warning signs:
  - the app shell wastes space
  - user tasks are visually secondary to decoration
  - operators must scroll too much for basic actions
- Corrective moves:
  - tighten density without sacrificing clarity
  - prioritize state, actions, and data over decoration
  - use real task surfaces, not hero-like panels

## AI Magic Without Control

- What it looks like: AI output feels flashy but users cannot inspect, edit, approve, or recover
- Why it happens: novelty outranks trust and workflow control
- Warning signs:
  - the system speaks confidently without showing what it did
  - no clear edit, retry, compare, or approve path exists
  - everything is forced through chat even when structure is needed
- Corrective moves:
  - show tool use, source, status, and next actions
  - add explicit review and approval states
  - break outputs into inspectable artifacts

## Fake Proof

- What it looks like: testimonials, numbers, or logos exist but do not create real trust
- Why it happens: placeholder-style proof gets used without specificity
- Warning signs:
  - stats have no frame of reference
  - testimonials lack names, roles, or outcomes
  - logos appear with no explanation of relevance
- Corrective moves:
  - use specific outcomes and named entities when possible
  - pair proof with context
  - remove decorative proof that adds no credibility

## Overbuilt Form

- What it looks like: too many fields, too many steps, too much friction before value is clear
- Why it happens: internal data wishes override conversion reality
- Warning signs:
  - more than a handful of required fields up front
  - optional details treated as mandatory
  - the form asks for more than the user understands yet
- Corrective moves:
  - ask only for what is needed to start
  - split advanced questions into later steps
  - explain what the user gets after submitting

## How To Use This Pack

1. Audit the screen with the [design-scorecard](../shared-references/design-scorecard.md) or project review process.
2. Name the top 1-3 failure patterns present.
3. Apply the corrective moves before polishing colors or motion.
4. Re-check mobile, proof, and CTA clarity after each correction.

## Core Rule

The job is not just to make the screen prettier.

The job is to stop predictable failure modes before they become the final design.
