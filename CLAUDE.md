# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository managed by [chezmoi](https://github.com/twpayne/chezmoi), located in the standard chezmoi source directory (`~/.local/share/chezmoi`). The repository contains personal configuration files for development tools, shell configurations, and system settings.

## Package Management and Dependencies

### aqua (Primary Package Manager)
- Use `aqua install --all --only-link` to install/update all tools
- Configuration files:
  - `home/dot_config/aquaproj-aqua/aqua.yaml` - Main tool definitions
  - `aqua.yaml` - Root configuration with treefmt
- Auto-sync via chezmoi hook: `home/run_onchange_after_aqua-load.sh.tmpl`

### Node.js Tools (via pnpm)
- Location: `home/dot_local/share/npm-tool/`
- Install: `cd ~/.local/share/npm-tool && aqua exec -- pnpm install`
- Auto-sync via chezmoi hook when package.json/pnpm-lock.yaml changes
- Contains LSP servers: vtsls, yaml-language-server, gh-actions-language-server, etc.
- Contains Claude Code CLI: @anthropic-ai/claude-code

### Python Tools (via uv)
- Location: `home/dot_local/share/python-tool/`
- Install: `cd ~/.local/share/python-tool && aqua exec -- uv sync`
- Auto-sync via chezmoi hook when pyproject.toml/uv.lock changes
- Contains: yamllint

### Neovim Plugins
- Managed by `lazy.nvim`
- Lockfile: `home/dot_config/nvim/lazy-lock.json`

## Common Commands

### Chezmoi Operations
- `chezmoi apply` - Apply dotfiles to home directory
- `chezmoi diff` - Show differences between source and target
- `chezmoi re-add` - Re-add modified files to source
- `chezmoi update` - Pull and apply changes from git repository

### Development Environment Setup
- `aqua install --all --only-link` - Install all development tools
- `nvim --headless "+Lazy! sync" +qa` - Update Neovim plugins
- Tools will auto-sync when configuration files change via chezmoi hooks

## Architecture and Key Configurations

### Neovim Setup (nvim)
- Custom Neovim configuration using mini.nvim ecosystem
- LSP setup with multiple language servers (Go, TypeScript, Rust, Lua, etc.)
- Plugin management via lazy.nvim
- Configuration: `home/dot_config/nvim/init.lua`
- LSP configuration: `home/dot_config/nvim/lua/lsp/init.lua`

### Shell Configuration (Fish)
- Fish shell with extensive abbreviations and integrations
- Configuration: `home/dot_config/private_fish/config.fish.tmpl`
- Integrations: fnm, direnv, starship, fzf, WezTerm/VSCode shell integration
- Custom functions for git operations and tool switching

### Terminal and UI
- Primary terminals: WezTerm, Ghostty
- Color scheme: Iceberg (consistent across tools)
- Status line: Starship prompt
- File manager integrations: fzf, mini.files

### Language Support
Languages with full LSP and tooling setup:
- Go: gopls, golangci-lint, delve debugger
- TypeScript/JavaScript: vtsls, biome formatter
- Rust: rust-analyzer
- Lua: lua-language-server, stylua formatter
- Python: uv package manager, yamllint
- Terraform: terraform-ls, tenv version manager
- TOML: tombi language server
- Typst: tinymist language server
- OCaml: opam package manager
- Haskell: ghcup toolchain manager

### File Structure Patterns
- `dot_*` files map to `.*` in home directory
- `private_*` files are not tracked in git after chezmoi apply
- `*.tmpl` files are Go templates processed by chezmoi
- `run_onchange_*` files execute when their content or dependencies change

## Development Workflows

### Making Configuration Changes
1. Edit files in the chezmoi source directory
2. Test changes: `chezmoi diff`
3. Apply changes: `chezmoi apply`
4. Commit and push to git repository

### Adding New Tools
1. Add to `home/dot_config/aquaproj-aqua/aqua.yaml`
2. Run `aqua install --all --only-link`
3. Add configuration files as needed in appropriate `dot_config` directories

### Neovim Plugin Management
1. Add plugin spec under `home/dot_config/nvim/lua/plugins/`
2. Sync plugins with `nvim --headless "+Lazy! sync" +qa`
3. Update lockfile `home/dot_config/nvim/lazy-lock.json` when needed

### Language Server Setup
- LSP configurations are in `home/dot_config/nvim/after/lsp/`
- Enable new LSP in `home/dot_config/nvim/lua/lsp/init.lua`
- Add language server to aqua.yaml if not available via npm/system package manager
