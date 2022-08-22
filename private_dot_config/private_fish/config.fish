bind \cg '__ghq_look'

eval (direnv hook fish)

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# fnm configuration
fnm env | source; or true