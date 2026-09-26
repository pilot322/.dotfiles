---
name: stage-implement
description: "Implement a piece of work based on a spec or set of tickets using subagents."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

Implement the work described by the user in the spec, tickets or handoff.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use the code-review skill to review the work.

Methodology: heavily utilize subagents for the implementation. If the plan is not broken down into steps already, decide how to break it down into steps and use subagents consecutively (not in parallel, unless the subagents will not get in each others' way) for each of the steps in order to maximize implementation accuracy and minimize your own context window's usage. Think of yourself as a coordinator and agent manager, not a developer.
