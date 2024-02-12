# fzf.fish is only meant to be used in interactive mode. If not in interactive mode and not in CI, skip the config to speed up shell startup
if not status is-interactive && test "$CI" != true
    exit
end

# Because of scoping rules, to capture the shell variables exactly as they are, we must read
# them before even executing _fzf_search_variables. We use psub to store the
# variables' info in temporary files and pass in the filenames as arguments.
# This variable is global so that it can be referenced by fzf_configure_bindings and in tests
set --global _fzf_search_vars_command '_fzf_search_variables (set --show | psub) (set --names | psub)'


# Install the default bindings, which are mnemonic and minimally conflict with fish's preset bindings
fzf_configure_bindings

if [ "$macOS_Theme" = light ]
  # HardHacker Light Theme for fzf in Fish shell
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color bg:'#f5f0ff',fg:'#282433',hl:'#118dc3',fg+:'#282433',bg+:'#d8d3eb'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color query:'#9a77cf',fg+:'#e965a5',hl:'#118dc3',hl+:'#118dc3'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color preview-bg:'#f5f0ff',preview-fg:'#282433'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color border:'#6a6a6a',gutter:'#d8d3eb',header:'#e965a5'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color info:'#e965a5',marker:'#e05661',pointer:'#eea825'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color prompt:'#9a77cf',spinner:'#118dc3',separator:'#6a6a6a'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color query:regular
else if [ "$macOS_Theme" = dark ]
  # HardHacker Theme for fzf in Fish shell
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color bg:'#282433',bg+:'#282433',fg:'#6a6a6a'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color query:'#6a6a6a',fg+:'#9a77cf',hl:'#118dc3',hl+:'#118dc3'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color preview-bg:'#282433',preview-fg:'#6a6a6a'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color border:'#6a6a6a',gutter:'#282433',header:'#1da912'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color info:'#1da912',marker:'#e05661',pointer:'#eea825'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color prompt:'#9a77cf',spinner:'#118dc3',separator:'#6a6a6a'
  set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS --color query:regular
end

# Doesn't erase autoloaded _fzf_* functions because they are not easily accessible once key bindings are erased
function _fzf_uninstall --on-event fzf_uninstall
    _fzf_uninstall_bindings

    set --erase _fzf_search_vars_command
    functions --erase _fzf_uninstall _fzf_migration_message _fzf_uninstall_bindings fzf_configure_bindings
    complete --erase fzf_configure_bindings

    set_color cyan
    echo "fzf.fish uninstalled."
    echo "You may need to manually remove fzf_configure_bindings from your config.fish if you were using custom key bindings."
    set_color normal
end
