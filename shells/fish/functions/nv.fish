#!/usr/bin/env fish
function nv -d "Launch Neovim"
    if count $argv >/dev/null
        nvim $argv
    else
        nvim
    end
end
