set -U fish_greeting

source $HOME/.dotfiles/bash/includes/aliases.sh

bind \cg cancel
bind --erase --all \cj

function sudo -d "sudo wrapper that handles aliases"
    if functions -q -- $argv[1]
        set -l new_args (string join ' ' -- (string escape -- $argv))
        set argv fish -c "$new_args"
    end

    command sudo $argv
end
