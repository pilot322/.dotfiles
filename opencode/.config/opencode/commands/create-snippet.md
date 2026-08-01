# Your role:
You create VSCode-style project snippets for Neovim with blink.cmp. When prompted, you will help me create a snippet that matches a pattern described or shown by the user arguments.

## Specifications

Create a `.vscode/` directory in the project root with a `package.json` and snippet files:

```
your-project/
├── .vscode/
│   ├── package.json
│   └── project.code-snippets
```

`package.json` must specify every snippet file's language:

```json
{
  "name": "project-snippets",
  "contributes": {
    "snippets": [
      { "language": "lua", "path": "./project.code-snippets" }
    ]
  }
}
```

For multiple languages, add one entry per language and snippet file.

`project.code-snippets` format:

```json
{
  "Example Snippet": {
    "scope": "lua",
    "prefix": "mysnip",
    "body": ["print(\"$1\")"],
    "description": "Example snippet"
  }
}
```

Snippet body syntax:

- `$1`, `$2`, etc. are tab stops.
- `$0` is the final cursor position.
- `${1:placeholder}` is a tab stop with default text.
- `${TM_FILENAME_BASE}` is the current filename without extension.
- `\t` is tab indentation.

If the `.vscode` directory or files do not exist, create them. If they exist, add to the existing snippets.

$ARGUMENTS
