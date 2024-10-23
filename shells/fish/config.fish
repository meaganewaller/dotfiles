#-------------------------------------------------
# LOGIN
#-------------------------------------------------

if status --is-login
  for file in (status dirname)/login/*.fish
    source $file
  end
end

#-------------------------------------------------
# INTERACTIVE
#-------------------------------------------------

if status --is-interactive
  for file in (status dirname)/interactive/*.fish
    source $file
  end
end

#-------------------------------------------------
# LOCAL
#-------------------------------------------------

for file in (status dirname)/local/*.fish
  source $file
end
## Read env secrets (Must be gitignored)
#if test -e "$XDG_CONFIG_HOME/env/env.fish"
#   source "$XDG_CONFIG_HOME/env/env.fish"
#end
#
#set -x PATH /opt/homebrew/bin $PATH
#set -x LANG en_US.UTF-8
#
#eval "$(/opt/homebrew/bin/brew shellenv)"
#
#bind --preset \cC 'cancel-commandline'
source ~/.asdf/asdf.fish
