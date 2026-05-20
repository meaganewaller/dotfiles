if status is-interactive
    if type -q starship
        starship init fish | source

        # Universal theme switcher → starship palette
        # See docs/adrs/0005-universal-theme-switcher.md. theme-lookup
        # resolves state file → catalog default → fail, so STARSHIP_PALETTE
        # is always set to something valid as long as the catalog is on
        # disk. fish_prompt re-runs it each prompt so live `theme <name>`
        # switches land in already-running shells.
        function _dotfiles_theme_starship --on-event fish_prompt
            set -l lookup "$HOME/.local/libexec/dotfiles/theme-lookup"
            test -x "$lookup"; or return 0
            set -l palette ($lookup starship 2>/dev/null)
            test -n "$palette"; and set -gx STARSHIP_PALETTE "$palette"
        end

        # Seed STARSHIP_PALETTE on shell start so the first prompt is correct.
        set -l lookup "$HOME/.local/libexec/dotfiles/theme-lookup"
        if test -x "$lookup"
            set -l palette ($lookup starship 2>/dev/null)
            test -n "$palette"; and set -gx STARSHIP_PALETTE "$palette"
        end
    end
end
