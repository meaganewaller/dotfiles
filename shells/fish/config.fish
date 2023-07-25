if status is-interactive
end

fish_config theme choose "Rosé Pine Moon" 
fish_add_path ~/.cargo/bin
fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin
fish_add_path /usr/local/opt/libpq/bin
fish_add_path ~/bin
fish_add_path ~/.local/bin

set fish_cursor_insert line
set fish_cursor_replace_one underscore

set fish_greeting
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x EDITOR nvim
set -x LS_COLORS "$(vivid generate dracula)"
bind ` accept-autosuggestion
bind \co 'open .'
bind -M insert ` accept-autosuggestion
alias nv nvim
alias lg lazygit

# exa
alias ls "exa --color=always --icons --group-directories-first"
alias la 'exa --color=always --icons --group-directories-first --all'
alias ll 'exa --color=always --icons --group-directories-first --all --long'
alias lt 'exa --tree --color=always --icons --group-directories-first --all'

# zoxide
zoxide init fish | source

#starship
set -x STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"
starship init fish --print-full-init | source
enable_transience

# fzf
fzf_configure_bindings --git_status=\cg --git_log=\cl --history=\cr --variables=\cv --directory=\cf --processes=\cp
set fzf_preview_dir_cmd exa --all --color=always --icons
set fzf_fd_opts --hidden --no-ignore
set -x FZF_DEFAULT_OPTS --cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4

#set -gx EDITOR nvim
#set -gx VISUAL $EDITOR
#set -gx PATH /usr/local/bin $PATH
#
#set PATH /usr/local/opt/libpq/bin $PATH
#set PATH $HOME/.cargo/bin $PATH
#set PATH $HOME/bin $PATH
#set PATH $HOME/.local/bin $PATH
#
#fish_add_path /usr/local/sbin
#
#set NODE_PATH /usr/local/lib/node_modules
#set -gx GOPATH $HOME/go
#set -gx PATH $PATH $GOPATH/bin
#
#set fzf_preview_dir_cmd exa --all --color=always
#set fzf_preview_file_cmd bat --color=always
#set fzf_fd_opts --hidden --exclude=.git
#
#fish_config theme choose "Rosé Pine Moon"
#
#alias ls='exa -l -g --icons --git --color=always'
#alias ll='exa -1 --icons --tree --git-ignore --color=always'
#alias lg='lazygit'
#alias nv='nvim'
## ggl - for googling
#alias gge="ggl -b='Brave'"
#alias gg="ggl"
#
#alias c='clear'
#alias pomo='pomo.sh'
#alias nvh='nvim.sh'
#
#fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --processes=\cp
#
#zoxide init fish | source
#set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"
#starship init fish --print-full-init | source
#function starship_transient_prompt_func
#  starship module character
#end
#starship init fish | source
#enable_transience
#fnm env --use-on-cd | source
#
# pnpm
set -gx PNPM_HOME "/Users/meaganwaller/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
