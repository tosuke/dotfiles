function docker-context-switch
    docker context list --format json \
        | jq --slurp --raw-output \
            'sort_by(.Current)|reverse|.[]|(if .Current then "*" else " " end)+" "+.Name' \
        | fzf \
        | string replace -r "^[\*\s]+" "" \
        | read -l select
    if test -n "$select"
        docker context use "$select"
    end
end
