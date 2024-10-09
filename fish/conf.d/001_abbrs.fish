abbr bi 	"brew install"
abbr bic 	"brew install --cask"
abbr bin	"brew info"
abbr binc 	"brew info --cask"
abbr bl 	"brew leaves"
abbr blr 	"brew leaves --installed-on-request"
abbr blp	"brew leaves --installed-as-dependency"
abbr bs		"brew search"

abbr c		clear
abbr cl		clear
abbr claer	clear
abbr clera	clear

abbr cx		"chmod +x"

abbr dc 	"docker compose"
abbr dcd	"docker compose down"
abbr dcdv	"docker compose down -v"
abbr dcr 	"docker compose restart"
abbr dcu 	"docker compose up -d"
abbr dps 	"docker ps --format 'table {{.Names}}\t{{.Status}}'"

abbr e		exit

abbr hd         "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m)\'"

abbr ka		killall
abbr kn		"killall node"

abbr o		"open ."
abbr oc		"overmind connect (overmind ps | fzf | awk '{print $1}')"
abbr ok		"overmind kill"
abbr or		"overmind restart"
abbr os		"overmind start -D"
abbr osl	"overmind start -l"

abbr rmr	"rm -rf"

abbr sf		"source ~/.config/fish/config.fish"

abbr x          "chmod +x (ls | gum filter --limit --header 'chmod +x')"
