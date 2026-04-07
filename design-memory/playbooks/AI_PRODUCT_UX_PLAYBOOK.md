# AI Product UX Playbook

This playbook is for AI-native products, copilots, agents, and AI features inside existing software.

Its job is to keep AI UX useful, trustworthy, and understandable instead of magical, vague, or frustrating.

## Core rule

Do not start by asking "how do we make this feel like ChatGPT?"

Start by asking:

- what job is the user trying to finish?
- where does the AI help most?
- what should stay manual?
- what needs approval?
- what needs to be visible?

## Pick the right interaction model

### 1. Plain chat

Use when the main value is:

- asking questions
- brainstorming
- summarizing
- tutoring
- simple back-and-forth assistance

Do not use plain chat as the only surface if the user really needs structure, records, approvals, or repeatable workflows.

### 2. Chat plus workspace

Use when the AI is helping with a real object such as:

- document
- ticket
- campaign
- task list
- dataset
- lead
- codebase

The conversation should sit beside the thing being changed, not replace it.

### 3. Embedded copilot

Use when AI should help inside an existing product surface:

- form filling
- writing help
- search help
- summarization
- recommendations
- data analysis

The best copilot often feels like a smart sidekick, not a separate app.

### 4. Agent workflow

Use when the AI is doing longer-running work:

- research
- multi-step generation
- tool use
- batch processing
- background execution

This needs job state, progress, logs, checkpoints, and clear outputs.

### 5. Approval-first agent

Use when the AI might take actions with risk:

- sending messages
- editing live data
- publishing content
- changing records
- executing code
- touching money or customer data

Never hide risk behind a pretty chat bubble.

## Non-negotiables for AI UX

- The user should know what the AI is doing right now.
- The user should know what inputs, tools, or context the AI is using.
- The user should know what changed after an AI action.
- The user should know how to interrupt, retry, or recover.
- The user should know when something still needs human approval.

## Strong patterns

### State visibility

Show clear states such as:

- thinking
- waiting
- running tools
- blocked
- needs approval
- complete
- failed

### Tool transparency

When tools are involved, render them as structured actions, not hidden magic.

Show:

- tool name
- what it did
- what it returned
- what changed next

### Output structure

Good AI output is often easier to use when rendered as:

- checklist
- table
- diff
- card
- timeline
- queue item
- editable draft

not just a long paragraph.

### Human control

Provide:

- approve
- reject
- edit before send
- rerun
- undo when possible
- clear next-step buttons

### Memory and context control

Make it clear:

- what the AI remembers
- what thread or project it is working in
- whether memory is temporary or saved
- how to reset or narrow context

## Anti-patterns

- chat-only UI for tasks that need structured workflows
- fake certainty when the system is unsure
- hiding tool usage and side effects
- long AI paragraphs with no actionable next step
- no distinction between draft and applied change
- "one big magic button" with no preview for risky actions
- making the user guess whether work is still running
- showing chain-of-thought style noise instead of useful progress

## AI product surfaces that usually matter

- composer
- suggestions
- thread history
- tool results
- diff or artifact preview
- approval controls
- memory/context indicator
- background job list
- session or project switcher
- failure and retry state

## Product-type guidance

### AI assistant products

- prioritize fast comprehension
- keep the composer simple
- make suggestions concrete
- do not over-decorate the chat

### AI copilots inside existing software

- keep the original product primary
- the AI should assist the workflow, not hijack it
- tie AI suggestions to the object on screen

### AI agent products

- treat the agent like a worker with jobs, status, and outputs
- show progress and checkpoints
- make background execution easy to understand

### AI coding and ops tools

- visibility and control matter more than delight
- show diffs, logs, file targets, and approvals
- make destructive actions feel deliberate

## Review questions

- Is chat the right interface here?
- Does the user know what the AI can do?
- Does the user know what the AI just did?
- Can the user inspect outputs before committing?
- Can the user recover when the AI is wrong?
- Is the surrounding workflow stronger because of AI, or just noisier?
