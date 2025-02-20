ZDOT_DIR="${HOME}/.config/zsh"

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

function load_plugin() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)

  if [ ! -d "$ZDOT_DIR/plugins/$PLUGIN_NAME" ]; then
    git clone "https://github.com/$1.git" "$ZDOT_DIR/plugins/$PLUGIN_NAME"

    if [[ "$1" = "romkatv/gitstatus" ]]; then
      while IFS='' read -r a; do
        echo "${"${"${"${a//'%196F'/%9F}"//'%39F'/%13F}"//'%178F'/%11F}"//'%76F'/%12F}"
      done < $ZDOT_DIR/plugins/gitstatus/gitstatus.prompt.zsh > $ZDOT_DIR/plugins/gitstatus/gitstatus.prompt.zsh.t
      mv $ZDOT_DIR/plugins/gitstatus/gitstatus.prompt.zsh{.t,}
    fi
  fi

  if [ "$2" = "." ]; then
    [[ -f "$ZDOT_DIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" ]] && \
      source "$ZDOT_DIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    [[ -f "$ZDOT_DIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh" ]] && \
      source "$ZDOT_DIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
  fi
}

load_plugin zsh-users/zsh-autosuggestions .

{
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#444b6a,underline"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  setopt APPEND_HISTORY
  setopt SHARE_HISTORY
  HISTFILE=$HOME/.zhistory
  SAVEHIST=100000
  HISTSIZE=999
  setopt HIST_EXPIRE_DUPS_FIRST
  setopt EXTENDED_HISTORY
  bindkey '^ ' autosuggest-accept
}

load_plugin jeffreytse/zsh-vi-mode .
{
  ZVM_VI_INSERT_ESCAPE_BINDKEY='^['
  ZVM_VI_INSERT_ESCAPE_BINDKEY='jk'
}

load_plugin romkatv/gitstatus
{
  source $ZDOT_DIR/plugins/gitstatus/gitstatus.prompt.zsh
}



load_plugin zsh-users/zsh-syntax-highlighting .
{
  # Must be loaded last
}

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-abbr:$FPATH

  autoload -Uz compinit
  compinit
fi

alias vim="nvim"

zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'

unsetopt BEEP
source ~/.gusto/init.sh


