#-------------------------------------------------
# SETTINGS
#-------------------------------------------------

umask 22
ulimit -c 0

#-------------------------------------------------
# VARIABLES
#-------------------------------------------------

set -x DOTFILES "$HOME/.dotfiles"

set -x EDITOR nvim
set -x PAGER less
set -x BLOCKSIZE K

set -x LANG "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"

set -x RLWRAP_HOME "$HOME/.rlwrap"
set -x FZF_DEFAULT_OPTS "--reverse --info=hidden --height=20 --cycle --border --multi --exact"
set -x FZF_CTRL_T_COMMAND "rg --files --no-ignore-parent --sort path"
set -x CLICOLOR 1 # used by `tree`, possibly others
set -x RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
set -x MANPAGER "vim +MANPAGER -"
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

#-------------------------------------------------
# PROMPT
#-------------------------------------------------

set -g fish_prompt_pwd_dir_length 0

set -g __fish_git_prompt_showcolorhints true
set -g __fish_git_prompt_showupstream verbose
set -g __fish_git_prompt_char_upstream_ahead '+'
set -g __fish_git_prompt_char_upstream_behind -

#-------------------------------------------------
# PATHS
#-------------------------------------------------

set -x PATH /opt/homebrew/bin $PATH

fish_add_path -g "$HOME/local/bin"
fish_add_path -g "$DOTFILES/bin"
fish_add_path -g "$DOTFILES/bin/local"
fish_add_path -g "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
