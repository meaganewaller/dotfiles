# Read env secrets (Must be gitignored)
if test -e "$XDG_CONFIG_HOME/env/env.fish"
   source "$XDG_CONFIG_HOME/env/env.fish"
end

set -x PATH /opt/homebrew/bin $PATH
set -x LANG en_US.UTF-8

eval "$(/opt/homebrew/bin/brew shellenv)"

bind --preset \cC 'cancel-commandline'

if type -q nvm
  function __nvm_auto --on-variable PWD
  nvm use --silent 2>/dev/null
  end
  __nvm_auto
end

if type -q pyenv
  status --is-interactive; and source (pyenv init -|pbsub)
end

# `ls` → `exa` abbreviation
# Requires `brew install exa`
if type -q exa
  abbr --add -g ls 'exa --long --classify --all --header --git --no-user --tree --level 1'
end
 
# `cat` → `bat` abbreviation
# Requires `brew install bat`
if type -q bat
  abbr --add -g cat 'bat'
end
 
# `rm` → `trash` abbreviation (moves files to the trash instead of deleting them)
# Requires `brew install trash`
if type -q trash
  abbr --add -g rm 'trash'
end

set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
starship init fish | source
enable_transience
