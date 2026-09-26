---
name: setup-tmxc-worktrees
description: Make a consumer repository runnable in independent tmux-coder worktrees. Use when asked to set up tmux-coder worktree hooks, isolate development environments across worktrees, or fix resource collisions between worktree sessions.
---

# Set up tmux-coder worktrees

Adapt the **repository being opened by tmux-coder**, not tmux-coder itself. Read [the Worktree Hook integration guide](https://github.com/pilot322/tmux-coder/blob/main/docs/worktree-hook-integration.md) for the hook contract, config syntax, port leasing, and lifecycle before making changes. If working in a different repository, locate this guide in the tmux-coder checkout or ask for it.

## 1. Inventory the runnable stack

Trace the actual development path: app and worker entry points, service definitions, `.env` loading, scripts, migrations, seeds, tests, and local tooling. Record every shared database/schema, listening port, cache namespace, queue/topic, upload directory or bucket, search index, container project/volume, and host-level socket/lock/PID path that the stack uses. For each resource, identify **every** consumer and the variable or config key controlling it. Identify credentials and other existing local values that a generated file must preserve. Finish when every shared mutable resource has an owner, all its consumers are known, and any resource that cannot be isolated is explicitly flagged to the user.

## 2. Make the stack parameterizable

Give each resource a per-worktree name, path, or port from one local configuration seam (usually a git-ignored `.env`), and make every consumer use that same value, including migrations, test helpers, CLI tasks, and container configuration. Keep a checked-in `.env.example` documenting the required keys and defaults; preserve existing config and secrets instead of overwriting them. Use identifiers safe for each service, stable for a session and distinct across projects and worktrees; account for sanitized names that could collide. Put worktree-local files under the worktree root. Finish when no active tool silently falls back to a shared mutable resource while running the worktree stack.

## 3. Wire the creation hook

Add or extend `.tmux-coder/.tmux-coder.toml` with `[worktree].on-create-script` pointing to a checked-in executable script inside the project (for example `.tmux-coder/setup-worktree.sh`). Preserve other config sections. Set `on-create-timeout` based on the real cold setup cost. The hook runs with its working directory at the new worktree root and receives the `TMUX_CODER_*` values documented in the guide. It should:

1. Resolve the required per-worktree identities and obtain each listening port with `tmux-coder acquire-port KEY --start N --end M` in the hook environment; propagate `TMUX_CODER_HOOK_TOKEN` unchanged.
2. Create the local configuration from the project's template without losing necessary credentials or machine-specific values. Ensure every tool actually loads the generated values (a file existing on disk is not enough).
3. Install dependencies before invoking tools that need them; provision only the isolated resources, then run migrations/seeds or other project-specific setup as needed.
4. Exit non-zero when setup fails. Make repeated provisioning safe without swallowing genuine failures. Never log secrets.

Finish when the declared hook is executable in Git, works from a freshly checked-out worktree, and has an adequate timeout. Plan teardown for external resources that outlive a deleted worktree; worktree-local files go away with the worktree, but databases/buckets do not.

## 4. Verify isolation

Run the repository's relevant tests and static checks. Check the hook's syntax and executable bit, config validity, `.env` ignore rule, and absence of committed secrets. Where tmux-coder and the required services are available, create **two disposable worktree sessions through tmux-coder**, run their normal stacks concurrently, and confirm distinct ports and resource names plus independent migrations/data. Use only known disposable resources for teardown. If a live check is unavailable, report exactly what remains unverified rather than claiming isolation. Finish by summarizing the resource mapping, changed files, tests, and any manual setup or cleanup required.
