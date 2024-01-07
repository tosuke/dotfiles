function __ghq_look -d 'search repository'
    ghq list \
        | fzf --scheme=path --preview "fish -c \"__ghq_preview {}\"" --preview-window="right:60%" \
        | read -l select
    if test -n "$select"
        builtin cd (ghq root)/"$select"
    end
    commandline -f repaint
end

