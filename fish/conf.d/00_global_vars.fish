set -gx EDITOR vim
set -gx VISUAL vim
set -gx SHELL /opt/homebrew/bin/fish

set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME "$HOME/.config"
set -q XDG_DATA_HOME;   or set -gx XDG_DATA_HOME "$HOME/.local/share"
set -q XDG_CACHE_HOME;  or set -gx XDG_CACHE_HOME "$HOME/.cache"

set -gx APPLICATIONS_HISTORY_PATH "$XDG_DATA_HOME/history"

set -x DD_AGENT_MAJOR_VERSION 7
set -x DD_SITE "us5.datadoghq.com"

set -gx GPG_TTY (tty)
set -gx SSH_KEY_PATH "$HOME/.ssh"

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

set -gx GREP_COLOR "1;37;45"

# Rust - cargo
set -gx CARGOBIN "$HOME/cargo/.bin"

set -gx LESSHISTFILE "$APPLICATIONS_HISTORY_PATH/less_history"
set -gx LESSKEY "$XDG_CONFIG_HOME/less/keys"

# Opt out of brew analytics
set -gx HOMEBREW_NO_ANALYTICS 1

