function git-logsearch
    git log --color=always --oneline --decorate \
    | fzf --ansi --no-sort -m --preview 'git show --color=always {1}' \
    | cut -d' ' -f1 \
    | xargs git rev-parse
end