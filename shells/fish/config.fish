# Read env secrets (Must be git-ignored)
if test -e "$XDG_CONFIG_HOME/env/env.fish"
    source "$XDG_CONFIG_HOME/env/env.fish"
end

zoxide init fish | source

if test -e ~/.asdf/asdf.fish
    # Manually add asdf dirs to path, to avoid having them prepended
    fish_add_path -aP ~/.asdf/bin
    fish_add_path -aP ~/.asdf/shims

    source ~/.asdf/asdf.fish
    fish_add_path ~/.asdf/installs/rust/nightly/bin
    fish_add_path ~/.asdf/installs/neovim/nightly/bin

    if ! test -e ~/.config/fish/completions/asdf.fish
        mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    end
end

# Try to improve startup time
# starship init fish | source
/usr/local/bin/starship init fish --print-full-init | source

# pnpm
set -gx PNPM_HOME "/Users/meagan/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end