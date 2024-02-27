abbr bi   "brew install"
abbr bic  "brew install --cask"
abbr bin  "brew info"
abbr binc "brew info --cask"
abbr bl   "brew leaves"
abbr blr  "brew leaves --installed-on-request"
abbr blp  "brew leaves --installed-as-dependency"
abbr bs   "brew search"

abbr c clear
abbr cl clear
abbr claer clear
abbr clera clear
abbr cx "chmod +x"

abbr dc "docker compose"
abbr dcd "docker compose down"
abbr dcdv "docker compose down -v"
abbr dcr "docker compose restart"
abbr dcu "docker compose up -d"
abbr dps "docker ps --format 'table {{.Names}}\t{{.Status}}'"

abbr e exit

abbr fi "fisher install"
abbr fr "fisher refresh"
abbr fu "fisher update"

abbr hd "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m)\'"

abbr ka killall
abbr kn "killall node"

abbr l "lsd  --group-dirs first -A"
abbr ld lazydocker
abbr lg lazygit
abbr ll "lsd  --group-dirs first -Al"
abbr lt "lsd  --group-dirs last -A --tree"

abbr mt "man tmux"
abbr mf "man fzf"
abbr mz "man zoxide"

abbr nb "npm run build"
abbr nd "npm run dev"
abbr ne "nvim .env"
abbr nf neofetch
abbr ni "npm install"
abbr nt "npm run test"
abbr nxdg "nx dep-graph"
abbr ns "nu seed"

abbr o "open ."
abbr oc "overmind connect (overmind ps | fzf | awk '{print $1}')"
abbr ok "overmind kill"
abbr or "overmind restart"
abbr os "overmind start -D"
abbr osl "overmind start -l"

abbr rmr "rm -rf"

abbr sf "source ~/.config/fish/config.fish"
abbr st "tmux source ~/.tmux.conf"

abbr th things-cli
abbr ta "tmux a"
abbr tat "tmux attach -t"
abbr td "t dotfiles"
abbr tk "tmux kill-server"
abbr tks "tmux kill-server"
abbr tr "tldr --list | fzf --header 'tldr (tealdeer)' --reverse --preview 'tldr {1} --color=always' --preview-window=right,80% | xargs tldr"
abbr tp "t --repo (pbpaste)"
abbr tn "tmux new -s (basename (pwd))"
abbr tt "touch .t && chmod +x .t && echo -e '#!/usr/bin/env bash\n' > .t && nvim .t"


abbr v "nvim +GoToFile"
abbr vfzf "nvim (fd --type f --hidden --follow --exclude .git | fzf-tmux -p -w 100 --reverse --preview 'bat --color=always --style=numbers --line-range=:500 {}')"
abbr va "nvim ~/.config/alacritty/alacritty.toml"
abbr vf "nvim ~/.config/fish/config.fish"
abbr vt "nvim ~/.tmux.conf"
abbr vp "nvim package.json"
abbr vim nvim

abbr x "chmod +x (ls | gum filter --limit --header 'chmod +x')"

abbr y yarn
abbr ya "yarn add"
abbr yad "yarn add -D"
abbr yb "yarn build"
abbr yd "yarn dev"
abbr ye "yarn e2e"
abbr yg "yarn generate"
abbr yi "yarn install --frozen-lockfile"
abbr yl "yarn lint"
abbr yp "yarn plop"
abbr ypm "yarn plop model"
abbr ys "yarn server"
abbr yt "yarn test"
abbr yu "yarn ui"
abbr yw "yarn web"

abbr za "zoxide add"
abbr ze "zoxide edit"

abbr :GoToCommand fzf-history-widget
abbr :GoToFile "nvim +GoToFile"
abbr :SmartGoTo "nvim +SmartGoTo"
abbr :Grep "nvim +Grep"
abbr :bd exit
abbr :q "tmux kill-server"
abbr :qa! "tmux kill-server"
