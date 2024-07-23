function __ghq_look -d 'search repository'
    ghq list \
        | fzf --scheme=path --preview "builtin cd "(ghq root)"/{}; git status" --preview-window="right:60%" \
        | read -l select
    if test -n "$select"
        builtin cd (ghq root)/"$select"
    end
    commandline -f repaint
end

