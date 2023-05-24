#!/usr/bin/env zsh

weather=$(curl -sL "https://wttr.in/Jacksonville?u&format=3")
temperature=$(echo "$weather" | cut -c2- | tr -d "+C ")

icon=$(
	echo "$weather" | cut -d" " -f1 |
		# replace emoji with nerdfont icons
		sed 's/🌧//' |
		sed 's/☁️//' |
		sed 's/🌫//' |
		sed 's/🌧//' |
		sed 's/❄️//' |
		sed 's/🌦//' |
		sed 's/🌨//' |
		sed 's/⛅️//' |
		sed 's/☀️//' |
		sed 's/🌩/󰖓/' |
		sed 's/⛈//'
)

if [[ "$weather" =~ Unknown ]] || [[ "$weather" =~ Sorry ]] || [[ -z "$weather" ]]; then
	icon=""
	temperature="–"
fi

sketchybar --set "$NAME" icon="$icon" label="$temperature"
