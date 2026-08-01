Your task:
1. Inspect the repository with `git status` and other relevant Git commands.
2. Group staged, unstaged, and untracked changes into logical commits using Conventional Commits.

Use this message format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Use `feat` for new functionality, `fix` for bug fixes, and conventional types such as `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, and `test` when appropriate. Mark breaking changes with `!` before the colon or a `BREAKING CHANGE:` footer.

3. Do not run `git add` or `git commit` yet. First propose the commit groups and messages to the user. Ask for clarification if the grouping is uncertain.
4. Create the approved groups and commits only after the user approves them.
