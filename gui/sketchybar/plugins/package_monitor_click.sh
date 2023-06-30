#!/usr/bin/env bash

USE='brew pnpm asdf mas pip gem'

if [[ -x "$(command -v brew)" ]] && [[ $USE == *"brew"* ]]; then
  osascript -e 'tell app "Terminal" to do script "brew upgrade"'
fi

if [[ -x "$(command -v pip)" ]] && [[ $USE == *"pip"* ]]; then
  osascript -e 'tell app "Terminal" to do script "pip-review --local --auto'
fi

if [[ -x "$(command -v npm)" ]] && [[ $USE == *"npm"* ]]; then
  osascript '-e tell app "Terminal" to do script "npm update -g"'
fi

if [[ -x "$(command -v yarn)" ]] && [[ $USE == *"yarn"* ]]; then
  osascript '-e tell app "Terminal" to do script "yarn global upgrade"'
fi

if [[ -x "$(command -v gem)" ]] && [[ $USE == *"gem"* ]]; then
  osascript '-e tell app "Terminal" to do script "gem update"'
fi

if [[ -x "$(command -v mas)" ]] && [[ $USE == *"mas"* ]]; then
   # runs the outdated command and stores the output as a list variable.
   masLIST=$(mas outdated)

   # checks to see if the returned list is empty. If so, it sets the outdated packages list to zero, if not, sets it to the line count of the list.
   if [[ $masLIST != "" ]]; then
     osascript '-e tell app "Terminal" to do script "mas upgrade"'
   fi
fi
