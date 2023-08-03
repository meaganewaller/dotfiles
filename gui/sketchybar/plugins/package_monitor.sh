#!/usr/bin/env bash

# TODO: Make this more general and not just for brew

# valid manager names are: `brew` `pnpm` `npm` `yarn` `asdf` `apm` `mas` `pip` `gem`
# USE='brew'

PREV_COUNT=$(sketchybar --query package_monitor | jq -r .popup.items | grep ".package*" -c)

# . ~/.local/bin/get-colorscheme

render_bar_item() {
  case "$COUNT" in
    [3-5][0-9])
      COLOR=0xff${COLOR_LOVE}
      ;;
    [1-2][0-9])
      COLOR=0xff${COLOR_GOLD}
      ;;
    [1-9])
      COLOR=0xff${COLOR_TEXT}
      ;;
    0)
      COLOR=0xff${COLOR_FOAM}
      COUNT=􀆅
      ;;
  esac

  sketchybar --set "$NAME" label="$COUNT" icon.color="$COLOR"
}

add_outdated_header() {
  brew_header=(
    label="$(echo -e 'Outdated Brews')"
    label.font="$FONT:Bold:14.0"
    label.align=left
    icon.drawing=off
    click_script="sketchybar --set $NAME popup.drawing=off"
  )

  sketchybar --set brew.details "${brew_header[@]}"

}

render_popup() {
  add_outdated_header

  COUNTER=0
  sketchybar --remove '/brew.package\.*/'

  if [[ -n "$OUTDATED" ]]; then
    while IFS= read -r package; do

      brew_package=(
        label="$package"
        label.align=right
        label.padding_left=20
        icon.drawing=off
        click_script="sketchybar --set $NAME popup.drawing=off"

      )
      item=brew.package."$COUNTER"

      sketchybar --add item "$item" popup."$NAME" \
        --set "$item" "${brew_package[@]}"

      COUNTER=$((COUNTER + 1))

    done <<<"$(echo -n "$OUTDATED" | grep '^')"
  fi
}

update() {
  brew update
  COLOR=0xff${COLOR_LOVE}
  OUTDATED=$(brew outdated)
  COUNT=$(echo -n "$OUTDATED" | grep -c '^')

  render_bar_item
  render_popup

  if [ "$COUNT" -ne "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
    sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
  fi
}

popup() {
  if [[ "$PREV_COUNT" -gt 0 ]]; then
    sketchybar --set "$NAME" popup.drawing="$1"
  else
    sketchybar --set "$NAME" popup.drawing=off
  fi
}

case "$SENDER" in
  "routine" | "forced")
    update
    ;;
  "mouse.entered")
    popup on
    ;;
  "mouse.exited" | "mouse.exited.global")
    popup off
    ;;
  "mouse.clicked")
    popup toggle
    ;;
esac

# if [[ -x "$(command -v brew)" ]] && [[ $USE == *"brew"* ]]; then
#   brewLIST=$(brew outdated)
#
#   if [[ $brewLIST == "" ]]; then
#     BREW='0'
#     brewLIST=""
#   else
#     BREW=$(echo "$brewLIST" | wc -l)
#   fi
# fi
#
# if [[ -x "$(command -v pip)" ]] && [[ $USE == *"pip"* ]]; then
#   pipLIST=$(pip list --outdated)
#   tempPIP=$(echo "$pipLIST" | wc -l)
#
#   if [[ $tempPIP -gt 1 ]]; then
#     PIP=$(($tempPIP - 2))
#   else
#     PIP="0"
#     pipLIST=""
#   fi
# fi
#
# if [[ -x "$(command -v npm)" ]] && [[ $USE == *"npm"* ]]; then
#   npm update &> /dev/null
#   npmLIST=$(npm outdated)
#
#   # checks to see if the returned list is empty. If so, it sets the outdated packages list to zero, if not, sets it to the line count of the list.
#   if [[ $npmLIST == "" ]]; then
#     NPM='0'
#     npmLIST=""
#   else
#     NPM=$(echo "npmLIST" | wc -l)
#   fi
# fi
#
# if [[ -x "$(command -v yarn)" ]] && [[ $USE == *"yarn"* ]]; then
#
#   # runs the outdated command and stores the output as a list variable.
#   yarnLIST=$(yarn outdated)
#
#   # checks to see if the returned list is empty. If so, it sets the outdated packages list to zero, if not, sets it to the line count of the list.
#   if [[ $yarnLIST == "" ]]; then
#     YARN='0'
#     yarnLIST=""
#   else
#     YARN=$(echo "$yarnLIST" | wc -l)
#   fi
# fi
#
# if [[ -x "$(command -v apm)" ]] && [[ $USE == *"apm"* ]]; then
#   apm update &> /dev/null
#
#    # runs the outdated command and stores the output as a list variable.
#    apmLIST="$(apm outdated)"
#
#    # checks to see if the returned list is empty. If so, it sets the outdated packages list to zero, if not, sets it to the line count of the list.
#    if [[ $apmLIST == *"empty"* ]]; then
#      APM='0'
#      apmLIST=""
#    else
#      tempAPM=$(echo "$apmLIST" | wc -l)
#      APM=$((tempAPM - 1))
#    fi
# fi
#
# if [[ -x "$(command -v gem)" ]] && [[ $USE == *"gem"* ]]; then
#
#    # runs the outdated command and stores the output as a list variable.
#    gemLIST=$(gem outdated)
#
#    # checks to see if the returned list is empty. If so, it sets the outdated packages list to zero, if not, sets it to the line count of the list.
#    if [[ $gemLIST == "" ]]; then
#      GEM='0'
#      gemLIST=""
#    else
#      GEM=$(echo "$gemLIST" | wc -l)
#    fi
# fi
#
# if [[ -x "$(command -v mas)" ]] && [[ $USE == *"mas"* ]]; then
#
#    # runs the outdated command and stores the output as a list variable.
#    masLIST=$(mas outdated)
#
#    # checks to see if the returned list is empty. If so, it sets the outdated packages list to zero, if not, sets it to the line count of the list.
#    if [[ $masLIST == "" ]]; then
#      MAS='0'
#      masLIST=""
#    else
#      MAS=$(echo "$masLIST" | wc -l)
#    fi
# fi
#
# DEFAULT="0"
#
# # sum of all outdated packages
# SUM=$((
#   ${BREW:-DEFAULT} +
#   ${CASK:-DEFAULT} +
#   ${PIP:-DEFAULT} +
#   ${NPM:-DEFAULT} +
#   ${YARN:-DEFAULT} +
#   ${APM:-DEFAULT} +
#   ${GEM:-DEFAULT} +
#   ${MAS:-DEFAULT}
# ))
#
# NONZERO="􀧢 "
# ZERO="􀆅 "
#
# if [[ $SUM -gt 0 ]]; then
#   sketchybar -m --set $NAME label="$SUM" \
#     icon="$NONZERO" \
#   else
#     sketchybar -m --set $NAME
# fi
