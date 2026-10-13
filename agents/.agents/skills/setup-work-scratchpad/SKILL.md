---
name: setup-work-scratchpad
description: Set up a scratchpad for multi-session, human-in-the-loop work and learning.
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

Set up a work scratchpad that preserves the goal, collaboration preferences, and recorded progress across sessions. Document the workflow inside the scratchpad so future sessions can follow it using README.md as their entry point.

# Setup

1. Establish the task goal, scope, and what completion would look like. For learning-oriented work, also establish what the user wants to understand. Use the conversation so far; ask only about consequential gaps.
2. Decide the collaboration approach with the user during this invocation. Use preferences they have explicitly stated for this task, or an existing agreement when reusing a scratchpad. If the approach is unspecified or consequential details are missing, ask the user how they want to work together and wait for their answer before finalizing the agreement.
   - Clarify who does what, the preferred size of work increments, when and how to explain the work, what the agent may do independently, and when to return to the user for discussion or a decision.
   - Keep the question focused on what is still undecided. Offer concrete suggestions when helpful, and let the user choose or describe their own approach.
   - Record the resulting working agreement in WORK-SCRATCHPAD-RULES.md so future sessions can follow it.
3. Choose a descriptive task name and check for an existing relevant scratchpad. Preserve existing contents; if reuse versus creating a new scratchpad is unclear, ask before writing.
4. Create or complete the files described below. Invoking this skill authorizes initialization and recording this setup as the first session. When reusing a scratchpad, follow its existing update rules and preserve its history.
5. Verify that the goal, working agreement, initial progress entry, and navigation links are present and consistent. Finish by giving the user the README path to pass to subsequent sessions.

# Structure

Create the scratchpad under the current working directory:

```text
.scratch/work-scratchpad-{task-name}/
  README.md
  PROGRESS.md
  WORK-SCRATCHPAD-RULES.md
```

The directory may also contain task artifacts such as codebase maps, explanations, worked examples, and experiment results.

# README.md

README is the only file guaranteed to be passed to each subsequent session. Keep it concise and sufficient to orient a new agent or human. Include:

- The task goal, scope, completion criteria, and learning goal when relevant.
- Essential context that cannot be recovered easily from the working files.
- A relative-link index explaining the role of each scratchpad file or directory. Group artifacts by directory when useful, with a local index if individual files need explanation.
- An explicit instruction for each new session to read WORK-SCRATCHPAD-RULES.md and follow its resumption procedure before continuing.

Keep current progress in PROGRESS.md and the working agreement in WORK-SCRATCHPAD-RULES.md; README links to those sources of truth.

# PROGRESS.md

Use these top-level headings:

```markdown
# Progress summary
# Sessions
```

The **progress summary** is a compact handoff as of the last recorded update. Include:

- The date of the last update, identifying initialization as setup.
- Current state: completed work and established findings, including relevant verification results.
- Important decisions and their rationale.
- Open questions and blockers.
- The next proposed increment and any pending user decision.
- When relevant, learning context: concepts covered, questions still open, and understanding explicitly confirmed by the user. Distinguish material explained from understanding confirmed.

Under **Sessions**, keep dated entries with each session's substantive work, findings, decisions, and supporting references. On an authorized update, refresh the summary and append a session entry, or extend the current session's entry if it already exists. Preserve earlier session history; make any corrections explicit.

Record initialization as the first session. Preserve resumption-critical state and rationale; link detailed explanations and evidence rather than copying the conversation.

# WORK-SCRATCHPAD-RULES.md

Write the task-specific working agreement and the following operating rules into this file. Future sessions must be able to follow them without loading this skill.

## Resuming a session

1. Read the progress summary in PROGRESS.md. Treat it as a checkpoint at the last recorded update; work since then may be absent.
2. Consult session entries and linked artifacts as needed.
3. Briefly reconcile the recorded state with the current user request and relevant working files, then propose or carry out the next increment as permitted by the working agreement.

## Collaboration

- Follow the agreed work increment, explanation style, autonomy, and discussion boundaries. Distinguish proposed next steps from user decisions already made.
- Change the goal or working agreement when the user requests or agrees to the change, updating README or this file respectively.

## Persistence

- Creating the initial files and recording the setup session are authorized by invoking this skill. After initialization, update PROGRESS.md only when the user explicitly requests a "scratchpad progress update" or equivalent. Neither ordinary task work nor ending a session authorizes a progress update.
- On a requested update, refresh the progress summary and record the session's substantive work according to the PROGRESS.md format. Update README links and context as needed to reflect agreed goal changes or new artifacts.
- Artifact contents and their README index entries may be maintained as part of requested work. Changes to goal or rules follow the collaboration rule above. These edits do not authorize a progress update; keep progress tracking in PROGRESS.md.
- Keep README and the progress summary concise. Preserve the information needed to resume, especially decisions and rationale, and link supporting detail from artifacts or session entries.
