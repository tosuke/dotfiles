set --global --export FZF_DEFAULT_OPTS "--height 40% --layout=reverse --cycle"
set --global --export EDITOR nvim
if not set -q NVIM_APPNAME
    set --global --export NVIM_APPNAME nvim
end
set --global --export TENV_AUTO_INSTALL "true"
