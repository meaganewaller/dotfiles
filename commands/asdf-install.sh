#!/usr/bin/env bash
# shellcheck shell=bash

log "setting up asdf for all platforms"

# clone asdf-vm (no need for homebrew version of asdf if we're doing this)
if [[ ! -d "$HOME/.asdf" ]]; then
  log_warn "$HOME/.asdf not found; cloning it now.."
  git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
fi

source "$HOME/.asdf/asdf.sh"

log "adding asdf plugins.."

asdf plugin-add clojure https://github.com/asdf-community/asdf-clojure.git
asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git
asdf plugin-add direnv https://github.com/asdf-community/asdf-direnv.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf plugin-add groovy https://github.com/weibemoura/asdf-groovy.git
asdf plugin-add haskell https://github.com/asdf-community/asdf-haskell.git
asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf plugin-add julia https://github.com/rkyleg/asdf-julia.git
asdf plugin-add kotlin https://github.com/asdf-community/asdf-kotlin.git
asdf plugin-add lazygit https://github.com/nklmilojevic/asdf-lazygit.git
asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git
asdf plugin-add luajit https://github.com/smashedtoatoms/asdf-luaJIT.git
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add ocaml https://github.com/asdf-community/asdf-ocaml.git
asdf plugin-add perl https://github.com/ouest/asdf-perl.git
asdf plugin-add php https://github.com/asdf-community/asdf-php.git
asdf plugin-add pnpm https://github.com/jonathanmorley/asdf-pnpm.git
asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
asdf plugin-add pre-commit https://github.com/jonathanmorley/asdf-pre-commit.git
asdf plugin-add python https://github.com/danhper/asdf-python.git
asdf plugin-add racket https://github.com/asdf-community/asdf-racket.git
asdf plugin-add rclone https://github.com/johnlayton/asdf-rclone.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf plugin-add scala https://github.com/asdf-community/asdf-scala.git
asdf plugin-add shellcheck https://github.com/luizm/asdf-shellcheck.git
asdf plugin-add stylua https://github.com/jc00ke/asdf-stylua.git
asdf plugin-add yarn https://github.com/twuni/asdf-yarn.git
asdf plugin-add zig https://github.com/cheetah/asdf-zig.git

echo "installing asdf plugin versions..."
# must initially symlink our tool-versions file for asdf to install the right things..
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl)"
asdf install
