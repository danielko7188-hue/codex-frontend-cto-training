# Motion And Interaction Pack 2026-04-07

This file maps high-value motion and interaction jobs to stronger real-world references and practical behavior rules.

Its purpose is feedback.

Good motion should improve orientation, confidence, and perceived quality.

Bad motion adds noise, delay, or confusion.

Use this pack when the layout looks fine but the interface still feels flat, abrupt, noisy, or unclear in motion.

## Page-Load Reveal

- Primary anchors: [Vercel](../reference-bank/love/vercel.md), [Linear](../reference-bank/love/linear.md), [Framer](../reference-bank/love/framer-home.md)
- Best for: landing pages, homepages, launches, premium marketing pages
- Borrow: quick staged reveals, one dominant entry, calm rhythm
- Rule: reveal hierarchy, not every object equally
- Watch out for: long intro animations that delay comprehension

## Hover And Focus Feedback

- Primary anchors: [Linear](../reference-bank/love/linear.md), [Shopify Polaris](../reference-bank/love/shopify-polaris.md), [Mercury](../reference-bank/love/mercury.md)
- Best for: buttons, cards, rows, nav items, tables, forms
- Borrow: crisp hover contrast, clear focus rings, lightweight movement
- Rule: feedback should confirm interactivity instantly
- Watch out for: hover states that are prettier than they are useful

## CTA Press / Submit Feedback

- Primary anchors: [Vercel](../reference-bank/love/vercel.md), [ServiceTitan](../reference-bank/love/servicetitan-home.md), [One Medical](../reference-bank/love/one-medical-home.md)
- Best for: forms, signup buttons, lead-gen pages, checkout-like flows
- Borrow: fast pressed state, disabled/loading clarity, success acknowledgement
- Rule: users should always know whether the click worked
- Watch out for: ambiguous buttons that look frozen during submission

## Form Validation And Recovery

- Primary anchors: [One Medical](../reference-bank/love/one-medical-home.md), [Airbnb Host Homes](../reference-bank/love/airbnb-host-homes.md), [Shopify Polaris](../reference-bank/love/shopify-polaris.md)
- Best for: multi-step forms, quote forms, onboarding, account setup
- Borrow: inline error clarity, field-level correction, calm success states
- Rule: help the user recover in-place, not after full submit failure
- Watch out for: generic red errors that do not explain how to fix the field

## Loading And Skeleton State

- Primary anchors: [Intercom Inbox](../reference-bank/love/intercom-inbox.md), [Retool](../reference-bank/love/retool-home.md), [ChatGPT Overview](../reference-bank/love/chatgpt-overview.md)
- Best for: dashboards, AI outputs, inboxes, data-heavy views
- Borrow: layout-preserving skeletons, short spinners only when needed, visible work-in-progress
- Rule: loading states should preserve structure and reduce jumpiness
- Watch out for: blank screens or generic spinners that erase context

## Empty-To-Filled Transition

- Primary anchors: [Notion](../reference-bank/love/notion-home.md), [Cal Teams](../reference-bank/love/cal-teams.md), [Intercom Inbox](../reference-bank/love/intercom-inbox.md)
- Best for: first-run dashboards, newly created workspaces, empty lists, zero-result views
- Borrow: gentle state change, preserved anchors, obvious next step
- Rule: the user should feel progress, not disorientation, when data appears
- Watch out for: hard swaps that make the screen feel unstable

## Progressive Disclosure

- Primary anchors: [Cloudflare](../reference-bank/love/cloudflare-home.md), [Shopify Polaris](../reference-bank/love/shopify-polaris.md), [Retool](../reference-bank/love/retool-home.md)
- Best for: settings, advanced filters, details panels, multi-step tools, enterprise workflows
- Borrow: reveal complexity only when needed, maintain context while expanding details
- Rule: simple by default, deeper on demand
- Watch out for: collapsing critical information behind tiny affordances

## Drawer / Side Panel / Modal Transition

- Primary anchors: [Claude Code](../reference-bank/love/claude-code.md), [Cal Teams](../reference-bank/love/cal-teams.md), [Shopify Polaris](../reference-bank/love/shopify-polaris.md)
- Best for: secondary tasks, settings, previews, approvals, AI sidekicks
- Borrow: clear source/destination relationship, restrained motion, stable background context
- Rule: transitions should explain where the panel came from and how to dismiss it
- Watch out for: overlays that feel detached from the user's current task

## AI Activity Feedback

- Primary anchors: [Claude Code](../reference-bank/love/claude-code.md), [OpenAI Codex](../reference-bank/love/openai-codex.md), [ChatGPT Overview](../reference-bank/love/chatgpt-overview.md)
- Best for: agent products, copilots, tool-using AI, background jobs
- Borrow: visible statuses, tool activity, blocked/running/needs approval states
- Rule: the user should know what the AI is doing right now and what still needs human input
- Watch out for: “thinking…” with no meaningful progress signal

## Streaming / Partial Output Reveal

- Primary anchors: [ChatGPT Overview](../reference-bank/love/chatgpt-overview.md), [Claude Code](../reference-bank/love/claude-code.md), [OpenAI Codex](../reference-bank/love/openai-codex.md)
- Best for: AI text generation, tool results, long-running drafts, code or analysis output
- Borrow: stable output area, readable incremental reveal, clear completion state
- Rule: streaming should improve speed without making the result harder to scan
- Watch out for: jittery text surfaces or layout shifts during streaming

## Success / Undo Feedback

- Primary anchors: [Shopify Polaris](../reference-bank/love/shopify-polaris.md), [Mercury](../reference-bank/love/mercury.md), [Intercom Inbox](../reference-bank/love/intercom-inbox.md)
- Best for: settings saves, mutations, queue actions, admin tools, AI approvals
- Borrow: short success messages, optional undo, visible result of the action
- Rule: confirm the action and make recovery easy when appropriate
- Watch out for: success toasts that disappear before the user understands what changed

## Motion Rules

1. Motion should explain change, not decorate it.
2. Speed should feel calm and confident, not lazy.
3. Prefer opacity, position, and scale changes over flashy transforms.
4. Preserve spatial continuity when something opens, closes, or updates.
5. For AI products, status feedback is more important than delight.
6. If motion slows task completion, remove it.

## How To Use This Pack

1. Choose the screen type with [SCREEN_TYPE_REFERENCE_PACK_2026-04-07.md](./SCREEN_TYPE_REFERENCE_PACK_2026-04-07.md).
2. Choose the pattern with [PATTERN_REFERENCE_PACK_2026-04-07.md](./PATTERN_REFERENCE_PACK_2026-04-07.md).
3. Choose the behavior job from this file.
4. Define what the user should understand before, during, and after the motion.
5. Verify that the interaction is clearer, not just more animated.

## Core Rule

Good motion makes the interface easier to trust.

Bad motion makes the interface harder to use.
