function __wezterm_set_user_var
    set -l name $argv[1]
    set -l value $argv[2]

    set -l value_base64 (echo -n $value | base64)

    if not set -q TMUX
        printf '\033]1337;SetUserVar=%s=%s\033\\' $name $value_base64
    else
        printf '\033Ptmux;\033\033]1337;SetUserVar=%s=%s\033\\033\\' $name $value_base64
    end
end
