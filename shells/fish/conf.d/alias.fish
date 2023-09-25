# alias for functions

# Docker
alias dl='docker ps'
alias dc='docker-compose'
alias dv='docker volume ls'
alias dce='docker-compose exec'
alias dcs='docker-compose stop'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dcu='docker-compose up -d'
alias dlog='docker-compose logs -f'
alias dx='docker system prune -a -f'
alias dub='docker-compose up -d --build'
alias dclear='docker rm -fv $(docker ps -aq)'
alias dcud='docker-compose -f docker-compose.dev.yml up -d'
alias dcsd='docker-compose -f docker-compose.dev.yml stop'
alias dcup='docker-compose -f docker-compose.prod.yml up -d'
alias dcsp='docker-compose -f docker-compose.prod.yml stop'

# Dotfiles
alias dot='dotfile_tasks'
alias ed='nvim ~/.dotfiles'
alias up='cd ~/.dotfiles && rake sync'
alias backup='cd ~/.dotfiles && rake backup'
alias clean='ruby ~/.dotfiles/commands/clean_up.rb'
alias icons='python ~/.dotfiles/commands/seticons.py'
alias bf='cd ~/.dotfiles && rake backup:files\[true\]'
alias cleanup='ruby ~/.dotfiles/commands/clean_up.rb ~/Downloads'

# Fish
alias fi='fisher install'
alias fl='fisher list'
alias fu='fisher update'
alias fr='fisher remove'

# Git
alias lg='lazygit'
alias ga='git add'
alias gp='git pull'
alias gaa='git add .'
alias gst='git status'
alias gc='git commit -m'
alias gnb='git checkout -b'
alias gpu='git push origin master'
alias gdm='git checkout -b dev-master'
alias nah='git reset --hard && git clean -df'
alias gfix='git rm -r --cached . && git add .'

# hledger
alias hf='hledger -f $FINANCES/transactions.journal -f $FINANCES/forecast.journal --auto --debug=2'
alias hfs='hledger -f $FINANCES/transactions.journal -f $FINANCES/forecast.journal --forecast="this month".. --auto --debug=2 bal "^(ass|liab)" --tree --cumul'
alias hb='hledger -f $FINANCES/transactions.journal -f $FINANCES/forecast.journal bal -M --tree --budget expenses'
alias hg='hledger-forecast generate -t $FINANCES/transactions.journal -f $FINANCES/forecast.csv -o $FINANCES/forecast.journal --verbose --force'
alias hs='hledger-forecast summarize -f $FINANCES/forecast.yml'

# Homebrew
alias br='brew remove'
alias bu='brew update'
alias bs='brew search'
alias bi='brew install'
alias bupg='brew upgrade && brew cleanup'

# Mac
alias code='open $argv -a "Visual Studio Code"'
alias reloadapps="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
alias disableNotificationCenter="launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && killall NotificationCenter"
alias enableNotificationCenter="launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && open /System/Library/CoreServices/NotificationCenter.app/"

# Misc
alias ls='ls --color=auto'
alias fk='fuck' # Overwrite mistakes
alias fck='fuck'
alias etxt='extract-text'
alias wifi='wifi-password'
alias div='print_divider'
alias dm='color-mode dark'
alias lm='color-mode light'
alias essh='nvim ~/.ssh/config'
alias chmodall='sudo chmod -R 0777'
alias copyssh='pbcopy < ~/.ssh/$1'
alias rk='pgrep kitty | xargs kill -SIGUSR1'
alias dotup='cd ~/.dotfiles && git submodule update --remote dotbot'
alias mssh='ruby ~/.dotfiles/commands/ssh.rb'
alias sep='ruby ~/.dotfiles/commands/make_separator.rb'

# Neovim / Vim
alias vi='nvim'
alias vim='/usr/local/bin/vim'
alias nvu='cd ~/.dotfiles && rake update:neovim && prevd'

# Rails
alias r='bin/rails'
alias rr='rails routes'
alias rrg='rails routes | grep'
alias rd='rails destroy'
alias rc='rails console'
alias rdb='rails dbconsole'
alias rcs='rails console --sandbox'
alias rs='rails server -p 3001'
alias rsd='rails server --debugger'
alias rsp='rails server --port'
alias rsb='rails server --bind'
alias rup='rails app:update'
alias rds='rails db:setup'
alias rdm='rails db:migrate'
alias rdmr='rails db:migrate:redo'
alias rgm='rails generate model'
alias rgc='rails generate controller'
alias rgmi='rails generate migration'
alias rtest='tail -f log/test.log'
alias rdev='tail -f log/development.log'
alias rprod='tail -f log/production.log'

# Ruby
alias rt='rake test'
alias sb='~/.local/share/nvim/mason/packages/solargraph/bin/solargraph bundle'
alias gb='gem build'
alias ug='gem update --system && gem update'

# Shell
alias c='clear'
alias tags='ctags -R'
alias ea='nvim ~/.config/fish/aliases.fish'
alias et='nvim ~/.config/tmux/tmux.conf'
alias src='source ~/.config/fish/config.fish && fish_logo'
alias reloaddns='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# Shell navigation
alias ..='cd ..'
alias bk='cd -'
alias home='cd ~'
alias ...='cd ../..'
alias desk='cd ~/Desktop'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ze='zoxide edit'
