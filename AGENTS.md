# Repository Guidelines

## Project Structure & Module Organization

This is a chezmoi source repository for user dotfiles. Files under `home/` map into the home directory: for example, `home/dot_config/nvim/` becomes `~/.config/nvim/`, and `dot_*` names become hidden files. Treat `private_*` paths as chezmoi metadata, not literal destination names. Go-template sources use `.tmpl`; `run_onchange_*` scripts run after relevant content changes.

Major areas include Neovim Lua configuration in `home/dot_config/nvim/`, Fish shell configuration in `home/dot_config/private_fish/`, terminal settings under `wezterm/` and `ghostty/`, and tool manifests under `home/dot_config/aquaproj-aqua/`. Managed Node and Python tools live in `home/dot_local/share/npm-tool/` and `python-tool/`.

## Development and Validation Commands

- `chezmoi diff`: preview how source changes affect the target home directory.
- `chezmoi apply --dry-run --verbose`: validate rendering and planned actions without applying them.
- `chezmoi apply`: install the current source state; review the diff first because hooks may run.
- `aqua install --all --only-link`: install or refresh tools declared in the aqua configuration.
- `aqua exec -- stylua --check home/dot_config/nvim`: check Lua formatting.
- `git diff --check`: detect whitespace errors before committing.

There is no repository-wide build or automated test suite. Validate the specific tool you changed and inspect `chezmoi diff`.

## Coding Style & Naming Conventions

Preserve the style of nearby configuration. Lua uses spaces and StyLua settings from `stylua.toml`; shell scripts should be POSIX-compatible unless their location clearly targets Fish or Bash. Keep YAML and TOML indentation consistent, and do not hand-edit generated lockfiles. Follow chezmoi naming conventions (`dot_`, `private_`, `.tmpl`, and `executable_`) when adding files.

## Testing Guidelines

Test narrowly: start Neovim after Lua changes, parse or source shell configuration in the intended shell, and run the relevant package manager after manifest changes. Never commit credentials or machine-specific rendered secrets. Check template output with `chezmoi execute-template < file.tmpl` when editing nontrivial templates.

## Commit & Pull Request Guidelines

History primarily uses concise dependency-update subjects and scoped Conventional Commit messages such as `feat(nvim): add md-render.nvim`. Use an imperative subject, add a scope when useful, and keep unrelated configurations in separate commits. Pull requests should explain the user-visible effect, list validation performed, link relevant issues, and include screenshots only for visual terminal or editor changes.
