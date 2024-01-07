# variables
if not set -q XDG_DATA_HOME
    set -gx XDG_DATA_HOME "$HOME/.local/share"
end
if not set -q XDG_CONFIG_HOME
    set -gx XDG_CONFIG_HOME "$HOME/.config"
end

# aqua
if not set -q AQUA_ROOT_DIR
    set AQUA_ROOT_DIR "$XDG_DATA_HOME/aquaproj-aqua"
end
if [ -d "$AQUA_ROOT_DIR" ]
    fish_add_path -g "$AQUA_ROOT_DIR/bin"
    set -q AQUA_GLOBAL_CONFIG || set -gx AQUA_GLOBAL_CONFIG "$XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml"
    set -q AQUA_POLICY_CONFIG || set -gx AQUA_POLICY_CONFIG "$XDG_CONFIG_HOME/aquaproj-aqua/aqua-policy.yaml"
end

# local
if [ -d $HOME/.local/bin ]
    fish_add_path -g "$HOME/.local/bin"
end

# Go
if [ -d $HOME/go ]
    fish_add_path -g "$HOME/go/bin"
end

# Rust
if [ -d $HOME/.cargo ]
    fish_add_path -g "$HOME/.cargo/bin"
end

# fnm (node.js)
if command -q fnm
    if status is-interactive
        fnm env --use-on-cd --version-file-strategy recursive --corepack-enabled | source
        or echo "fnm initialization failed"
    end
end

# opam
if [ -f $HOME/.opam/opam-init/init.fish ]
    source $HOME/.opam/opam-init/init.fish; or echo "opam initialization failed"
end

# interactice shells
if not status is-interactive
    return
end

# starship
if status is-interactive && command -q starship
    starship init fish | source; or echo "starship initialization failed"
end

# direnv
if status is-interactive && command -q direnv
    direnv hook fish | source; or echo "direnv: initialization failed"
end

# shell integration for VSCode (OSC 633)
if string match -q "$TERM_PROGRAM" vscode
    source (code --locate-shell-integration-path fish); or echo "VSCode shell integration failed"
end

# key bindings
bind \cg __ghq_look

# abbrs
# Git
abbr --add --global -- g git
abbr --add --global -- gl git-logsearch
abbr --add --global -- gc 'git commit'
abbr --add --global -- gp 'git push'
abbr --add --global -- gpf 'git push --force-with-lease'

abbr --add --global -- k kubectl
abbr --add --global -- a aws
abbr --add --global -- te terraform

# Node.js
abbr --add --global -- pn pnpm
