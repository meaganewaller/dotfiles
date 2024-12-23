set -gx fish_user_paths ~/.local/bin $fish_user_paths

fish_add_path /opt/homebrew/opt/openssl@3.0/bin

set -gx LDFLAGS "-L/opt/homebrew/opt/openssl@3/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/openssl@3/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/openssl@3/lib/pkgconfig"

set -gx PNPM_HOME "$HOME/Library/pnpm"

fish_add_path $PNPM_HOME
