# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a LazyVim-based Neovim configuration that extends the default LazyVim setup with custom plugins and configurations. The configuration is built on top of lazy.nvim plugin manager and follows LazyVim's plugin structure.

## Key Architecture

- **Base**: LazyVim starter template with custom extensions
- **Plugin Manager**: lazy.nvim with automatic plugin loading from `lua/plugins/` directory
- **Configuration Structure**:
  - `init.lua`: Entry point that bootstraps lazy.nvim
  - `lua/config/`: Core configuration (options, keymaps, autocmds)
  - `lua/plugins/`: Individual plugin configurations loaded automatically by lazy.nvim
  - `after/plugin/`: Additional plugin configurations loaded after lazy.nvim

## Development Commands

### Formatting
```bash
# Format Lua files using stylua
stylua lua/ init.lua --config-path stylua.toml
```

### Plugin Management
```bash
# Open lazy.nvim plugin manager (from within Neovim)
:Lazy
```

## Configuration Patterns

### Plugin Configuration
- Each plugin gets its own file in `lua/plugins/`
- Plugin files return a table with plugin specs
- Use `enabled = false` to disable plugins without removing them
- Configuration follows LazyVim's plugin structure with `opts` tables

### Custom Options
- Core Neovim options are set in `lua/config/options.lua`
- Custom settings include Greek language mapping, 4-space indentation, and disabled features like autoformat and spell check

### Custom Keymaps
- Additional keymaps are defined in `lua/config/keymaps.lua`
- Includes Greek keyboard layout support via `langmap`
- Custom leader key mappings for file operations, terminal integration, and GitLab issue creation

## Important Configuration Details

### Language Support
- Greek keyboard layout is fully supported through `langmap` configuration
- Terminal integration with tmux sessionizer
- GitLab CLI integration for issue creation

### File Operations
- Uses `trash-put` for safe file deletion in netrw
- Custom keymaps for common dotfile editing (.env, .gitignore)

### UI Customizations
- Word wrap toggle functionality
- Bufferline toggle with persistent state
- Custom terminal mode escape mapping

## Plugin Architecture Notes

- Plugins are organized by functionality in separate files
- LSP configuration is minimal and delegates to LazyVim defaults
- Theme and UI plugins are configured individually
- Development tools like Avante AI assistant are included but disabled by default

## File Structure Conventions

```
lua/
├── config/          # Core configuration
│   ├── lazy.lua     # lazy.nvim setup
│   ├── options.lua  # Neovim options
│   ├── keymaps.lua  # Custom keymaps
│   └── autocmds.lua # Autocommands
└── plugins/         # Plugin configurations
    ├── *.lua        # Individual plugin specs
    └── example.lua  # LazyVim example (disabled)
```

Each plugin file should return a table containing lazy.nvim plugin specifications that will be automatically loaded.