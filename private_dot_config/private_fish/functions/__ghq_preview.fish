function __ghq_preview
    set -l repo (ghq root)/$argv[1]
    if test -f $repo/README.md
        bat --color=always --style=plain $repo/README.md
        return
    end
end
