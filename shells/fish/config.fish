#
#source ~/.config/fish/private.fish
#
#fish_config theme choose Lover
#
#set -x GPG_TTY (tty)
#set -x HOMEBREW_NO_ANALYTICS
#set -x PYENV_ROOT "$HOME/.pyenv"
## XDG defaults
#set -Ux XDG_CACHE_HOME $HOME/.cache
#set -Ux XDG_CONFIG_HOME $HOME/.config
#set -Ux XDG_DATA_HOME $HOME/.local/share
#set -Ux XDG_DATA_DIRS /usr/local/share:/usr/share
#
## ZSH settings
#set -Ux ZDOTDIR $XDG_CONFIG_HOME/zsh
#set -Ux HISTFILE $ZDOTDIR/.zhistory
#set -Ux HISTSIZE 10000
#set -Ux SAVEHIST 10000
#
## Programming languages and their dependenices
#set -Ux CARGOBIN $HOME/.cargo/bin
#set -Ux DENOBIN $HOME/.deno/bin
#set -Ux GOBIN $HOME/go/bin
#set -Ux GOPATH $HOME/go
#set -Ux LOCALBIN $HOME/.local/bin
#set -Ux N_PREFIX "$HOME/n"
#set -Ux NBIN "$N_PREFIX/bin"
#set -Ux PRETTIERD_DEFAULT_CONFIG $HOME/.config/prettier/.prettierrc
#set -Ux NVIMBIN $HOME/.local/nvim/bin
#set -Ux YARNBIN $HOME/.yarn/bin
#
## Default env variables that are useful
#set -Ux EDITOR nvim
#set -Ux VISUAL nvim
#set -Ux SUDO_EDITOR "nvim -u NORC"
#set -Ux MANPAGER "nvim -c 'Man!' -"
#
#set fish_cursor_insert line
#set fish_cursor_replace_one underscore
#set fish_greeting
#set -x XDG_CONFIG_HOME "$HOME/.config"
#set -x LS_COLORS "$(vivid generate dracula)"
#bind ` accept-autosuggestion
#bind \co 'open .'
#bind -M insert ` accept-autosuggestion
#alias lg lazygit
#
## exa
#alias ls "exa --color=always --icons --group-directories-first"
#alias la 'exa --color=always --icons --group-directories-first --all'
#alias ll 'exa --color=always --icons --group-directories-first --all --long'
#alias lt 'exa --tree --color=always --icons --group-directories-first --all'
#
## neovim
#abbr nv "nvim"
#abbr vi "nvim"
#
#fish_add_path "$HOME/.dotfiles/bin"
#fish_add_path $CARGOBIN
#fish_add_path $DENOBIN
#fish_add_path -a $GOBIN
#fish_add_path -a $LOCALBIN
#fish_add_path -a $NBIN
#fish_add_path -a $NVIMBIN
#fish_add_path -a $YARNBIN
#
## Linux settings
#if test (uname -s) = Linux
#    # setup keychain settings if not in tmux
#    if test -z $TMUX && status --is-interactive
#        # SHELL=/usr/bin/fish /usr/bin/keychain --eval --quiet -Q gl_vincit gh_vincit gh_personal | source
#        set -l fish_cmd (command -v fish)
#        set -l ls_cmd (command -v ls)
#        set -l keychain_cmd (command -v keychain)
#        set -l ssh_keys ($ls_cmd ~/.ssh | grep -v -e pub -e known_hosts -e config)
#        # echo "SHELL=$fish_cmd $keychain_cmd --agents ssh --eval --quiet -Q $ssh_keys | source"
#        SHELL=$fish_cmd $keychain_cmd --eval --quiet -Q $ssh_keys | source && echo "Loaded $ssh_keys from ~/.ssh"
#    end
#
#    # Debian settings
#    if test -f /etc/debian_version
#        # Set `bat` as default man pager
#        alias bat batcat
#        # Alias for fd package
#        alias fd fdfind
#        # redefine for debian, where fd is renamed
#        set -Ux FZF_DEFAULT_COMMAND 'fdfind --type f --color=never'
#        # Alias for ncal to use normal month formatting
#        alias cal 'ncal -b'
#    end
#else if test (uname -s) = Darwin
#    # update $PATH to use gnu coreutils and commands instead of bsd defaults
#    set -p PATH /usr/local/opt/gnu-sed/libexec/gnubin
#end
#
## zoxide
#if type -q zoxide
#	zoxide init fish | source
#	set -x _ZO_DATA_DIR "$HOME/.local/share/zoxide"
#	set -x _ZO_ECHO 1
#	set -x _ZO_RESOLVE_SYMLINKS 1
#end
#
##starship
#set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
#
#if status is-interactive
#	load_env_vars ~/.env
#	thefuck --alias | source
#	starship init fish --print-full-init | source
#	enable_transience
#	source ~/.asdf/asdf.fish
#	source ~/.config/op/plugins.sh
#end
#
## fzf
#fzf_configure_bindings --git_status=\cg --git_log=\cl --history=\cr --variables=\cv --directory=\cf --processes=\cp
#set fzf_preview_dir_cmd exa --all --color=always --icons
#set fzf_fd_opts --hidden --no-ignore
#set -x FZF_DEFAULT_OPTS --cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
#
## bat
#set -x BAT_THEME Dracula
#
## tealdeer
#set -x TEALDEER_CONFIG_DIR "$HOME/.config/tealdeer"
#
#fnm env --use-on-cd | source
#set -gx PNPM_HOME "$HOME/Library/pnpm"
#if not string match -q -- $PNPM_HOME $PATH
#  set -gx PATH "$PNPM_HOME" $PATH
#end
#
#set -gx GOPATH $HOME/go
#set -gx GOROOT $HOME/.go
#set -gx PATH $GOPATH/bin $PATH
#
#fish_add_path /usr/local/sbin
#fish_add_path /usr/local/bin
