# Read env secrets (Must be gitignored)
if test -e "$XDG_CONFIG_HOME/env/env.fish"
   source "$XDG_CONFIG_HOME/env/env.fish"
end
