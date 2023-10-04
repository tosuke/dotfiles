# starship
if which starship > /dev/null
  starship init fish | source
end

bind \cg '__ghq_look'

# direnv hook
if which direnv > /dev/null
  eval (direnv hook fish)
end

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# fnm configuration
if which fnm > /dev/null
    fnm env | source; or true
end