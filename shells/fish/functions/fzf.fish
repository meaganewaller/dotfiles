function fzf --wraps="fzf"
  set -x FZF_DEFAULT_OPTS
  set -a FZF_DEFAULT_OPTS --height=70%
  # set -a FZF_DEFAULT_OPTS --multi
  set -a FZF_DEFAULT_OPTS --border
  # set -a FZF_DEFAULT_OPTS --preview-window=:hidden
  set -a FZF_DEFAULT_OPTS --history=$HOME/.fzf_history
  # set -a FZF_DEFAULT_OPTS --bind=ctrl-t:top
  set -a FZF_DEFAULT_OPTS --marker='✓'


  set -g fzf_fd_opts --hidden --no-ignore --exclude=.git --exclude=Library

  command fzf
end
