---
name: setup-work-scratchpad
description: Set up a scratchpad for organizing multistep work.
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

The user wants you to organize a 'work scratchpad' to organize multi-session work to accomplish some goal.

# What a work scratchpad is

A work scratchpad is a directory under the current working directory with the following structure:

.scratch/work-scratchpad-{task-name}/
- README.md
- PROGRESS.md
- RULES.md

The work scratchpad can also contain other artifacts and files generated during the work related to achieving the goal.

# README.md

This file contains the information necessary for an agent (and humans) to quickly understand what the goal is and how to work within the scratchpad's context. It's the only file that will be passed to each consecutive session, and should thus be self-contained and index all other files/directories in the scratchpad along with its role. It should POINT to the progress file for agents (and humans) to understand progress so far, not contain it.

# PROGRESS.md

This file is basically an aggregated log of all progress made in past sessions.
It follows this format:

<format>
    # Progress summary
    # Sessions
</format>

Consider this prompt to be the first 'session' that initializes the scratch 'workspace'.

# Work scratchpad rules and WORK-SCRATCHPAD-RULES.md

These are subject to change upon user request, but generally:
- Only update the progress-tracking portion of the work scratchpad when explicitly told 'scratchpad progress update' or similar by the user. This should most of the time only update PROGRESS.md. If it is reasonable to also change README.md because the goal changed or new artifacts exist that should be pointed to, you can do that. NEVER update the progress-tracking portion of the scratchpad when not explicitly told to.
- The main artifacts (README and PROGRESS) should be fairly concise (especially the README), but without losing any useful information to subsequent sessions.

Again, this skill is to set up AND document this whole process in a single directory. Store the rules for working in the work scratchpad inside WORK-SCRATCHPAD-RULES.md , and point README.md to it. These rules can be altered slightly depending on the work, depending on the user.
