---
name: setup-program-use
description: Set up a project-local skill so an agent can launch, see, and test one app surface (web, mobile, or terminal).
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Set Up Program Use

Create a **use skill** for one runnable project/surface in the current repository. Its job is to let a later agent reach the real app, exercise a representative state, and observe the result. If the repo has several apps (web, Android, TUI), decide which one this skill covers; create separate use skills when their launch, authentication, or observation paths differ.

1. **Explore, then grill.** Inspect the repo's projects, run scripts, env *key names* (not values), seeders/fixtures, existing agent skills, and available connection tools. Call the Skill tool with `grilling` to resolve the remaining decisions with the user: target app and platform, local/test environment, allowed test accounts and data resets, and how an agent should connect. Find discoverable facts in the repo rather than asking for them. Wait for shared understanding before writing.

2. **Trace a complete use path.** Establish and verify, in order:
   - **Start and address:** exact working directory and start command; where host, port, device ID, or tmux target come from; how to tell the app is ready. Resolve configured values before trying defaults.
   - **Connection and observation:** the tool actually available to the later agent (e.g. Chrome DevTools for web, emulator + device automation for Android, tmux pane for a TUI), how to attach, send input, and inspect output, errors, and relevant logs. If a needed tool is missing, surface the prerequisite rather than pretending the path works.
   - **Authentication and state:** how to select a role-appropriate seeded user, where credentials are obtained safely, how sessions persist or reset, which seeder/fixture yields each useful scenario, and which commands modify or wipe data. Ask before destructive reseeds. Never copy secrets or entire `.env` contents into the skill.
   - **Proof:** perform one harmless interaction on the target surface, inspect its visible result and errors, and record what worked. If verification is blocked, state precisely what remains unverified.

3. **Write the use skill.** Follow the repo's existing skill layout; otherwise use `.opencode/skills/<app>-use/SKILL.md`. Give it a narrow description triggered by requests to see, interact with, or test *that app*. Write actionable sections for finding the address, launching and attaching, authenticating with seeded data, reaching alternate states, and checking visible output/errors. Point to configuration and fixture files rather than caching machine-specific addresses, secrets, or passwords. Include prerequisites and the verified path; mark unverified steps explicitly. Show the draft to the user before writing it.

Done when the target and connection are agreed, the use skill is written, and a later agent can follow its documented path—or the exact missing prerequisite is recorded.
