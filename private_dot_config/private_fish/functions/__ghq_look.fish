function __ghq_look -d 'search repository'
  ghq list | fzf | read -l select
  if test -n "$select"
    builtin cd (ghq root)"/$select"
  end
  commandline -f repaint
end