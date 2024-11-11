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

if test -e "$HOME/.config/fish/private.fish"
    source "$HOME/.config/fish/private.fish"
end

# Added by `rbenv init` on Fri Nov  8 15:25:20 EST 2024
status --is-interactive; and rbenv init - --no-rehash fish | source
