if status is-interactive
    if type -q starship
        starship init fish | source

        # Universal theme switcher → starship palette
        # See docs/adrs/0005-universal-theme-switcher.md. Re-reading the
        # state file on each prompt means `theme <name>` takes effect on
        # the next prompt of any already-running shell.
        function _dotfiles_theme_starship --on-event fish_prompt
            set -l state_home $XDG_STATE_HOME
            test -z "$state_home"; and set state_home "$HOME/.local/state"
            set -l state "$state_home/theme/starship"
            test -r "$state"; and set -gx STARSHIP_PALETTE (head -n1 $state)
        end

        # Seed STARSHIP_PALETTE on shell start so the first prompt is correct.
        set -l state_home $XDG_STATE_HOME
        test -z "$state_home"; and set state_home "$HOME/.local/state"
        set -l state "$state_home/theme/starship"
        test -r "$state"; and set -gx STARSHIP_PALETTE (head -n1 $state)
    end
end
