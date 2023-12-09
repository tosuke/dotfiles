# if interactive shell
if not status is-interactive
    return
end

# fnm (node.js)
if command -q fnm;
    fnm env --use-on-cd --version-file-strategy recursive --corepack-enabled | source; \
        or echo "fnm initialization failed"
else
    echo "fnm: not found"
end

# opam
if [ -f $HOME/.opam/opam-init/init.fish ];
    source $HOME/.opam/opam-init/init.fish; or echo "opam initialization failed"
else
    echo "opam: not found"
end

# starship
if command -q starship;
    starship init fish | source; or echo "starship initialization failed"
else
    echo "starship: not found"
end

# direnv
if command -q direnv;
    direnv hook fish | source; or echo "direnv: initialization failed"
else
    echo "direnv: not found"
end

# shell integration for VSCode (OSC 633)
if string match -q "$TERM_PROGRAM" "vscode";
    source (code --locate-shell-integration-path fish); or echo "VSCode shell integration failed"
end

# key bindings
bind \cg '__ghq_look'

# abbrs
# Git
abbr --add --global -- g git
abbr --add --global -- gl 'git log --oneline'
abbr --add --global -- gc 'git commit'
abbr --add --global -- gp 'git push'
abbr --add --global -- gpf 'git push --force-with-lease'

abbr --add --global -- k kubectl
abbr --add --global -- a aws
abbr --add --global -- te terraform
