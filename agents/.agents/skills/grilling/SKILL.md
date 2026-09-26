---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is **usually** your job, not the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.):

**If the user does not say 'ask facts' in their prompt**:
dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

**If the user says 'ask facts' in their prompt:**
for one round, don't ask the frontier questions. Instead, ask the user for the facts you need, format your response like so:
```
💭 **F1** - **<fact title>**: <fact body, might be multiple paragraphs>

💭 **F2** - ... and so on
```

Easily findable facts should not be asked. The point of the 'ask facts' mode is to take advantage of the user's understanding of the project and codebase in order to save time, tool calls and tokens. The user can answer the question directly, point you to a file or directory or give you a hint, or just not know. In the last cases, launch subagents for the facts, using the user's guidance if provided. Rule of thumb: if the fact can be retrieved in less than 4 tool calls, it's easily findable.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
