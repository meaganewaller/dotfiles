export NIX_PATH="/Users/meagan.waller/.nix-defexpr/channels:/Users/meagan.waller/.nix-defexpr/channels::
/Users/meagan.waller/.nix-defexpr/channels:/Users/meagan.waller/.nix-defexpr/channels:nixpkgs=/nix/var/nix
/profiles/per-user/root/channels/nixpkgs:/nix/var/nix/profiles/per-user/root/channels"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
if [ -e /Users/meagan.waller/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/meagan.waller/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
