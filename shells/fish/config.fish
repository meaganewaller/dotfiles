set -u fish_greeting ""

# Variables
set -x GPG_TTY (tty)
set -x EDITOR nvim
set -x DOTNET_CLI_TELEMETRY_OUTPUT 1
set -x HOMEBREW_NO_ANALYTICS 1
set -x GOPATH "$HOME/go"
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
set -gx macOS_THEME (cat $HOME/.color_mode | string collect)
set -x PYENV_ROOT "$HOME/.pyenv"
set -x DIP_SHELL 1
set -x DIP_EARLY_ENVS "PATH,SHELL,WINDOWID,COLORTERM,XPC_FLAGS,__CFBundleIdentifier,SSH_AUTH_SOCK,_ZO_RESOLVE_SYMLINKS,KITTY_PID,GPG_TTY,EDITOR,PWD,LOGNAME,macOS_THEME,MANPATH,PNPM_HOME,LaunchInstanceID,KITTY_PUBLIC_KEY,ASDF_DEFAULT_TOOL_VERSIONS_FILENAME,COMMAND_MODE,HOME,LANG,SECURITYSESSIONID,STARSHIP_SHELL,STARSHIP_CONFIG,KITTY_WINDOW_ID,TMPDIR,ASDF_DATA_DIR,_ZO_ECHO,STARSHIP_SESSION_KEY,_ZO_DATA_DIR,HOMEBREW_NO_ANALYTICS,TERMINFO,TERM,ASDF_DIR,USER,SHLVL,DOTNET_CLI_TELEMETRY_OUTPUT,XPC_SERVICE_NAME,KITTY_LISTEN_ON,PYENV_ROOT,ASDF_CONFIG_FILE,FZF_DEFAULT_OPTS,RUBYLIB,KITTY_INSTALLATION_DIR,GOPATH,__CF_USER_TEXT_ENCODING"
set -x DIP_PROMPT_TEXT "ⅆ"
set -x VIMRUNTIME ""

set fish_color_param cyan
set fish_pager_color_completion blue --bold
set fish_color_normal black
set fish_color_error red
set fish_color_comment gray
set fish_color_autosuggestion gray

if [ "$macOS_Theme" = light ]
  set -x LS_COLORS "vivid generate $HOME/.config/vivid/hardhacker-light.yml"
else if [ "$macOS_Theme" = dark ]
  set -x LS_COLORS "vivid generate $HOME/.config/vivid/hardhacker-dark.yml"
end

# Paths
fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.dotfiles/bin"
fish_add_path "$HOME/.local/share/nvim/mason/bin"
fish_add_path "$HOME/.local/bin"

if type -q zoxide
  zoxide init fish | source
  set -x _ZO_DATA_DIR "$HOME/.local/share/zoxide"
  set -x _ZO_ECHO 1
  set -x _ZO_RESOLVE_SYMLINKS 1
end

if status is-interactive
  load_env_vars ~/.env
  thefuck --alias | source
  starship init fish --print-full-init | source
  enable_transience
end

fnm env --use-on-cd | source
# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
source ~/.asdf/asdf.fish
source ~/.config/op/plugins.sh
