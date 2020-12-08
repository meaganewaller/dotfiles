alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias lh='ls -d .*'                                 # Show hidden files/dirs only
alias lsd='ls -aFhlG'
alias ls='ls -GFh'                                  # Colorize output, add file type indicator, and put sizes in human readable format
alias ll='ls -GFhl'                                 # Same as above, but in long listing format
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias 'dus=du -sckx * | sort -nr'                   # Directories sorted by size
alias 'wordy=wc -w * | sort | tail -n10'            # Sort files in current directory by the number of words they contain
alias 'filecount=find . -type f | wc -l'            # Number of files (not directories)

# Mac Only
if [[ $IS_MAC -eq 1 ]]; then
	alias ql='qlmanage -p 2>/dev/null'                # OS X Quick Look
	alias oo='open .'                                 # Open current directory in OS X Finder
	alias 'today=calendar -A 0 -f /usr/share/calendar/calendar.mark | sort'
	alias 'mailsize=du -hs ~/Library/mail'
	alias 'smart=diskutil info disk0 | grep SMART'    # display SMART status of hard drive

	# alias to show all Mac App store apps
	alias apps='mdfind "kMDItemAppStoreHasReceipt=1"'

	# refresh brew by upgrading all outdated casks
	alias refreshbrew='brew outdated | while read cask; do brew upgrade $cask; done'

	# rebuild Launch Services to remove duplicate entries on Open With menu
	alias rebuildopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.fram ework/Support/lsregister -kill -r -domain local -domain system -domain user'
fi

# Database
alias 'psqlstart=/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start'
alias 'psqlstop=/usr/local/pgsql/bin/pg_ctl stop'

# curiosities
# gsh shows the number of commits for the current repos for all developers
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"

# gu shows a list of all developers and the number of commits they've made
alias gu="git shortlog | grep -E '^[^ ]'"

# Other Stuff
alias 'rm=rm -i' # make rm command (potentially) less destructive

# Force TMUX to use 256 colors
alias tmux='TERM=xterm-256color tmux'

alias vim='nvim'
alias vi='nvim'
alias v='nvim'

alias dm='docker-machine'
alias dc='docker-compose'
alias docker-cleanup='docker ps -a | grep Exit | cut -d ' ' -f 2 | xargs docker rm'

alias screenfetch='screenfetch-c'

alias ber='nocorrect bundle exec rspec '