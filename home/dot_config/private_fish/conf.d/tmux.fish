if not set -q TMUX
    return
end

set -g __tmux_sync_vars SSH_AUTH_SOCK SSH_CONNECTION DISPLAY

function __tmux_sync_environment
    tmux show-environment | while read -l line
        if string match -q -- '-*' $line
            set -l name (string sub -s 2 -- $line)
            if contains -- $name $__tmux_sync_vars
                set -e $name
            end
        else if string match -q '*=*' -- $line
            set -l parts (string split -m 1 '=' -- $line)
            if contains -- $parts[1] $__tmux_sync_vars
                set -gx $parts[1] $parts[2]
            end
        end
    end
end

# Sync on startup
__tmux_sync_environment

# Sync before each command
function __tmux_preexec --on-event fish_preexec
    __tmux_sync_environment
end
