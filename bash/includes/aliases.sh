# Aliases

alias sudo='sudo '
alias q='exit'
alias x='exit'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias mv='mv --interactive'
alias rm='rm --interactive=once'

alias ls='ls --color=auto --literal --group-directories-first --human-readable --format=vertical --indicator-style=slash'
alias ll='ls -l'
alias la='la --almost-all'
alias lla='lla -l --almost-all'

alias ln='ln --interactive'

alias df='df --human-readable'
alias du='du --human-readable'

alias grep='grep --color=auto'

alias s='ddgr --gui-browser --noprompt !ddg'
alias j='z'
alias jj='z -d'
alias b='prevd'
alias f='nextd'

alias iex='iex --erl "-kernel shell_history enabled"'
alias zed="zeditor"
