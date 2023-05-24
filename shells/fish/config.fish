export XDG_CONFIG_HOME=$HOME/.config
set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx PATH /usr/local/bin $PATH
# set -gx PATH /usr/local/sbin $PATH
set PATH /usr/local/opt/libpq/bin $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/bin $PATH
set PATH $HOME/.local/bin $PATH

fish_add_path /usr/local/sbin

set NODE_PATH /usr/local/lib/node_modules
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin

set fzf_preview_dir_cmd exa --all --color=always
set fzf_preview_file_cmd bat --color=always
set fzf_fd_opts --hidden --exclude=.git

fish_config theme choose "Rosé Pine Moon"

alias ls='exa -l -g --icons --git --color=always'
alias ll='exa -1 --icons --tree --git-ignore --color=always'
alias lg='lazygit'
alias nv='nvim'
# ggl - for googling
alias gge="ggl -b='Brave'"
alias gg="ggl"

alias c='clear'
alias pomo='pomo.sh'
alias nvh='nvim.sh'

fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp

zoxide init fish | source
set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"
function starship_transient_prompt_func
  starship module character
end
starship init fish | source
enable_transience
fnm env --use-on-cd | source

# set fish_greeting ""
#

#
# # editor
# export EDITOR="nvim"
# export VISUAL="nvim"
#
# fish_add_path ~/.cargo/bin/
# fish_add_path ~/.local/share/nvim/mason/bin/
# fish_add_path ~/.local/bin/
# fish_add_path ~/.bin
# fish_add_path ~/bin
#
# fish_vi_key_bindings
# set -g fish_vi_force_cursor 1
# set fish_cursor_insert line
# set fish_cursor_replace_one underscore
# set fish_cursor_replace underscore

# starship init fish | source
#
# set -x _ZO_ECHO 1
# zoxide init fish | source
#
# # # Read env secrets
#
# # if test -e "$XDG_CONFIG_HOME/env/env.fish"
# #   source "$XDG_CONFIG_HOME/env/env.fish"
# # end
#
# # /usr/local/bin/starship init fish --print-full-init | source
# # # set -gx EDITOR nvim
# # # set -gx VISUAL $EDITOR
# # # set -gx SHELL /usr/local/bin/fish
# # #
# # # # Ensure XDG variables are set
# # # set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME "$HOME/.config"
# # # set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME "$HOME/.local/share"
# # # set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME "$HOME/.cache"
# # #
# # # set -gx APPLICATIONS_HISTORY_PATH "$XDG_DATA_HOME/history"
# # #
# # # # Much faster than brew --prefix which depends on Ruby slow start time
# # # set -gx BREW_PREFIX /usr/local/opt
# # #
# # # set -gx GPG_TTY (tty)
# # # set -gx SSH_KEY_PATH "$HOME/.ssh"
# # #
# # # set -gx LANG en_US.UTF-8
# # # set -gx LC_ALL en_US.UTF-8
# # #
# # # set -gx OPENSSL_PATH "$BREW_PREFIX/openssl@3"
# # # set -gx PAGER bat
# # # set -gx LIBRARY_PATH "$OPENSSL_PATH/lib/"
# # #
# # # set -gx GREP_COLOR "1;37;45"
# # #
# # # # set -q JAVA_HOME; or set -gx JAVA_HOME "/Users/giladpeleg/.asdf/installs/java/adoptopenjdk-11.0.11+9"
# # # set -q GRADLE_USER_HOME; or set -gx GRADLE_USER_HOME "$XDG_DATA_HOME/gradle"
# # #
# # # # Go settings
# # # set -gx GOPATH "$HOME/go"
# # # set -gx GOBIN "$GOPATH/bin"
# # # set -gx GOROOT "$BREW_PREFIX/go/libexec"
# # #
# # # # Rust - cargo
# # # set -gx CARGOBIN "$HOME/cargo/.bin"
# # #
# # # set -gx LESSHISTFILE "$APPLICATIONS_HISTORY_PATH/less_history"
# # # set -gx LESSKEY "$XDG_CONFIG_HOME/less/keys"
# # #
# # # # A hack for https://github.com/gatsbyjs/gatsby/issues/6654
# # # set -gx GATSBY_CONCURRENT_DOWNLOAD 25
# # #
# # # set -gx POETRY_VIRTUALENVS_PATH "$HOME/.virtualenvs"
# # #
# # # set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/.npmrc"
# # # set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
# # #
# # # # Opt out of brew analytics
# # # set -gx HOMEBREW_NO_ANALYTICS 1
# # #
# # # # Python
# # # set -gx PIP_REQUIRE_VIRTUALENV true
# # # set -gx PIP_DEFAULT_TIMEOUT 30
# # # set -gx PIP_CACHE_DIR "$XDG_CACHE_HOME/pip"
# # #
# # # # Ruby bundler
# # # set -gx BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundle"
# # # set -gx BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME/bundle"
# # # set -gx BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundle"
# # #
# # # # Ruby GEM
# # # set -gx GEM_HOME "$XDG_DATA_HOME/gem"
# # # set -gx GEM_SPEC_CACHE "$XDG_CACHE_HOME/gem"
# # #
# # # set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir=$OPENSSL_PATH --with-readline-dir=$BREW_PREFIX/readline --with-libyaml-dir=$BREW_PREFIX/libyaml"
# # # # set -gx SDKROOT (xcrun --show-sdk-path)
# # #
# # # # Set iPython and Jupyter paths
# # # set -gx IPYTHONDIR "$XDG_CONFIG_HOME/jupyter"
# # # set -gx JUPYTER_CONFIG_DIR "$XDG_CONFIG_HOME/jupyter"
# # #
# # # # Set NVM dir
# # # set -gx NVM_DIR "$XDG_DATA_HOME/nvm"
# # # set -gx NODE_REPL_HISTORY "$APPLICATIONS_HISTORY_PATH/node_repl_history"
# # #
# # # # Httpie
# # # set -gx HTTPIE_CONFIG_DIR "$XDG_CONFIG_HOME/httpie"
# # #
# # # # Use build enhancement for Docker
# # # set -gx DOCKER_BUILDKIT 1
# # #
# # # set -gx REDISCLI_HISTFILE "$APPLICATIONS_HISTORY_PATH/redis_history"
# # # set -gx SQLITE_HISTORY "$APPLICATIONS_HISTORY_PATH/sqlite_history"
# # #
# # # set -gx BABEL_CACHE_PATH "$XDG_CACHE_HOME/babel/babel.json"
# # #
# # # set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"
# # #
# # # set -gx PIPX_BIN_DIR "$HOME/.local/bin"
# # # set -gx PATH $PATH $PIPX_BIN_DIR
# # #
# # # # Clojure lein
# # # set -gx LEIN_JVM_OPTS "-XX:+TieredCompilation -XX:TieredStopAtLevel=2"
# # #
# # # set -gx ASDF_CONFIG_FILE "$XDG_CONFIG_HOME/asdf/.asdfrc"
# # #
# # #
# # # fish_add_path --path \
# # #     /usr/local/sbin \
# # #     $PIPX_BIN_DIR \
# # #     $OPENSSL_PATH/bin \
# # #     $BREW_PREFIX/mysql@5.7/bin \
# # #     $GEM_HOME/bin \
# # #     $BREW_PREFIX/tcl-tk/bin \
# # #     $GOBIN \
# # #     $CARGOBIN
# # #
# # #
# # #
# # #
# # # # set -U fish_greeting
# # # #
# # # # fish_vi_key_bindings
# # # #
# # # # set -gx BROWSER brave
# # # # set -gx EDITOR nvim
# # # # set -gx FILE nnn
# # # # set -gx READER zathura
# # # # set -gx PAGER "bat --plain"
# # # # # set -gx STATUSBAR sketchybar
# # # # set -gx TERMINAL kitty
# # # # set -gx VISUAL $EDITOR
# # # #
# # # # set -gx MANPAGER "nvim +Man!"
# # # #
# # # # set -gx GOPATH $HOME/go
# # # # fish_add_path $HOME/.local/bin
# # # # fish_add_path $GOPATH/bin
# # # # fish_add_path $HOME/.cargo/bin
# # # # fish_add_path $HOME/.local/share/nvim/mason/bin
# # # #
# # # # # FZF options
# # # # set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git --exclude node_modules'
# # # # set -gx FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border --info=inline --marker="*" --bind "ctrl-y:execute(echo {+} | wl-copy)" --bind "ctrl-a:select-all" --bind "?:toggle-preview"'
# # # # set fzf_history_opts --sort --exact --history-size=30000
# # # # set fzf_fd_opts --hidden --follow --exclude=.git
# # # # set fzf_preview_dir_cmd exa --all --color=always
# # # #
# # # # fzf_configure_bindings --git_status=\e\cs --history=\cr --variables --git_log=\e\cl --directory=\cp
# # # #
# # # #
# # # #
# # # # fish_add_path ~/bin
# # # # fish_add_path ~/.local/bin
# # # # fish_add_path ~/.cargo/bin
# # # # fish_add_path ~/.local/share/nvim/mason/bin
# # # #
# # # # if status is-login
# # # #     if type -q nvim
# # # #         set -gx EDITOR nvim
# # # #     else
# # # #         set -gx EDITOR vim
# # # #     end
# # # #
# # # #     set -gx fish_greeting
# # # #     set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
# # # #
# # # #     ! set -q LANG; and set -gx LANG "en_US.UTF-8"
# # # # end
# # # #
# # # # if status is-interactive
# # # #   alias v $EDITOR
# # # #   type -q xdg-open; and type -q setsid; and alias open="setsid xdg-open"
# # # #   type -q lazygit; and alias lzg lazygit
# # # #   set -q ASDF_DIRENV_BIN; and alias direnv $ASDF_DIRENV_BIN
# # # #   type -q hx; and function hx
# # # #     PATH="$HOME/.local/share/nvim/mason/bin:$PATH" command hx $argv
# # # #   end
# # # #
# # # #   type -q zoxide; and zoxide init fish | source
# # # #   type -q starship; and starship init fish | source
# # # #   type -q atuin; and atuin init fish --disable-up-arrow | source
# # # # end
# # # # # set -x DOTNOT_CLI_TELEMETRY_OPTOUT 1
# # # # # set -x HOMEBREW_NO_ANALYTICS 1
# # # # # set -x CARGO_NET_GIT_FETCH_WITH_CLI true
# # # # # set -x GOPATH "$HOME/go"
# # # # # set PATH $PATH $GOPATH/bin
# # # # # set -gx TERM xterm-256color
# # # #
# # # # # set -g theme_color_scheme terminal-dark
# # # #
# # # # # set -u fish_greeting ""
# # # #
# # # # # set -gx LC_ALL "en_US.UTF-8"
# # # # # set -gx LANG "en_US.UTF-8"
# # # # # set -gx SSH_AUTH_SOCK "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
# # # # # set -gx XDG_CONFIG_HOME "$HOME/.config"
# # # # # set -gx XDG_DATA_HOME "$HOME/.local/share"
# # # #
# # # # # set -gp fish_user_paths "/usr/local/sbin"
# # # # # set -gp PATH /usr/local/opt/gnu-sed/libexec/gnubin
# # # # # set -gp PATH (go env GOPATH)/bin
# # # #
# # # # # set -gx BAT_THEME 'Dracula'
# # # # # set -gx GPG_TTY (tty)
# # # #
# # # # # set pipenv_fish_fancy yes
# # # # # set -gx PIPENV_PYPI_MIRROR https://mirrors.ustc.edu.cn/pypi/web/simple
# # # # # alias v 'vim'
# # # # # alias l 'exa --icons'
# # # # # alias h 'history'
# # # # # alias tailf 'tail -f'
# # # #
# # # # # # Fundle init
# # # # # if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end
# # # # # fundle plugin 'dracula/fish'
# # # # # fundle plugin 'laughedelic/fish_logo'
# # # # # fundle plugin 'oh-my-fish/plugin-osx'
# # # # # fundle plugin 'joehillen/to-fish'
# # # # # fundle plugin 'edc/bass'
# # # # # fundle plugin 'danhper/fish-ssh-agent'
# # # # # fundle plugin 'tuvistavie/fish-fastdir'
# # # # # fundle plugin '0rax/fish-bd'
# # # # # fundle plugin 'sentriz/fish-pipenv'
# # # # # fundle plugin 'jorgebucaran/getopts.fish'
# # # # # fundle plugin 'jorgebucaran/replay.fish'
# # # # # fundle plugin 'patrickf1/fzf.fish'
# # # # # fundle plugin 'joehillen/ev-fish'
# # # # # fundle plugin 'docker/cli' --path 'contrib/completion/fish'
# # # # # fundle init
# # # #
# # # # # # Autojump
# # # # # [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
# # # #
# # # # # alias ls "ls -p -G"
# # # # # alias la "ls -A"
# # # # # alias ll "ls -l"
# # # # # alias lla "ll -A"
# # # # # alias g git
# # # # # #command -qv nvim && alias vim nvim
# # # #
# # # # # # fish_add_path /opt/homebrew/bin
# # # # # fish_add_path /usr/bin/fish
# # # #
# # # # # alias c clear
# # # # # alias dco "docker-compose"
# # # # # alias de "docker exec"
# # # # # alias dr "docker run"
# # # # # alias dps "docker ps"
# # # # # alias dpa "docker ps -a"
# # # # # alias di "docker images"
# # # #
# # # # # alias e exit
# # # #
# # # # # fish_add_path /usr/local/bin
# # # # # fish_add_path /usr/local/sbin
# # # # # fish_add_path "$HOME/.dotfiles/bin"
# # # # # fish_add_path "$HOME/.cargo/bin"
# # # # # fish_add_path "$HOME/.local/share/nvim/mason/bin"
# # # #
# # # # # set -gx EDITOR nvim
# # # # # set -gx PATH bin $PATH
# # # # # set -gx PATH ~/bin $PATH
# # # # # set -gx PATH ~/.local/bin $PATH
# # # # # set -gx PATH node_modules/.bin $PATH
# # # # # set -g GOPATH $HOME/go
# # # # # set -gx PATH $GOPATH/bin $PATH
# # # # # set -gx PATH $HOME/.cargo/bin $PATH
# # # #
# # # # # string match -q "$TERM_PROGRAM" "vscode"
# # # # # and . (code --locate-shell-integration-path fish)
# # # #
# # # # # set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
# # # # # if test -f $LOCAL_CONFIG
# # # # #   source $LOCAL_CONFIG
# # # # # end
# # # #
# # # #
# # # # #   installed direnv && direnv hook fish | source
# # # # #   set -g direnv_fish_mode eval_on_arrow    # trigger direnv at prompt, and on every arrow-based directory change (default)
# # # # #   set -g direnv_fish_mode eval_after_arrow # trigger direnv at prompt, and only after arrow-based directory changes before executing command
# # # # #   set -g direnv_fish_mode disable_arrow    # trigger direnv at prompt only, this is similar functionality to the original behavior
# # # #
# # # # #   installed thefuck && thefuck --alias | source
# # # # #   set -x STARSHIP_CONFIG $HOME/.config/starship/starship.toml
# # # # #   installed starship && starship init fish | source
# # # # #   installed atuin && atuin init fish | source
# # # # #   installed zoxide && zoxide init fish | source
# # # # #   for mode in insert default normal
# # # # #     installed atuin && bind -M insert \e\[A "_atuin_search; tput cup \$LINES"
# # # # #     bind -M $mode \a _project_jump
# # # # #   end
# # # # #   set -x GIT_MERGE_AUTOEDIT no
# # # # #   set -x MANPAGER "nvim -c 'Man!' -o -"
# # # # #   set -x EDITOR nvim
# # # #
# # # # # end
