#!/usr/bin/env bash

MODE="${MODE:-$(get-system-theme)}"

# source: https://rosepinetheme.com/palette/ingredients
dark_base="232136"
dark_surface="2a273f"
dark_overlay="393552"
dark_muted="6e6a86"
dark_text="e0def4"
dark_love="eb6f92"
dark_gold="f6c177"
dark_rose="ea9a97"
dark_pine="3e8fb0"
dark_foam="9ccfd8"
dark_iris="c4a7e7"
dark_highlight_low="2a283e"
dark_highlight_med="44415a"
dark_highlight_high="56526e"

light_base="faf4ed"
light_surface="fffaf3"
light_overlay="f2e9e1"
light_muted="9893a5"
light_subtle="797593"
light_text="575279"
light_love="b4637a"
light_gold="ea9d34"
light_rose="d7827e"
light_pine="286983"
light_foam="56949f"
light_iris="907aa9"
light_highlight_low="f4ede8"
light_highlight_med="dfdad9"
light_highlight_high="cecacd"

case $MODE in
  dark)
    base="$dark_base"
    surface="$dark_surface"
    overlay="$dark_overlay"
    muted="$dark_muted"
    subtle="$dark_subtle"
    text="$dark_text"
    love="$dark_love"
    gold="$dark_gold"
    rose="$dark_rose"
    pine="$dark_pine"
    foam="$dark_foam"
    iris="$dark_iris"
    highlight_low="$dark_highlight_low"
    highlight_med="$dark_highlight_med"
    highlight_high="$dark_highlight_high"
    ;;
  light)
    base="$light_base"
    surface="$light_surface"
    overlay="$light_overlay"
    muted="$light_muted"
    subtle="$light_subtle"
    text="$light_text"
    love="$light_love"
    gold="$light_gold"
    rose="$light_rose"
    pine="$light_pine"
    foam="$light_foam"
    iris="$light_iris"
    highlight_low="$light_highlight_low"
    highlight_med="$light_highlight_med"
    highlight_high="$light_highlight_high"
    ;;
esac

export COLOR_BASE="$base"
export COLOR_SURFACE="$surface"
export COLOR_OVERLAY="$overlay"
export COLOR_MUTED="$muted"
export COLOR_SUBTLE="$subtle"
export COLOR_TEXT="$text"
export COLOR_LOVE="$love"
export COLOR_GOLD="$gold"
export COLOR_ROSE="$rose"
export COLOR_PINE="$pine"
export COLOR_FOAM="$foam"
export COLOR_IRIS="$iris"
export COLOR_HIGHLIGHT_LOW="$highlight_low"
export COLOR_HIGHLIGHT_MED="$highlight_med"
export COLOR_HIGHLIGHT_HIGH="$highlight_high"

# # Color Palette
# export BASE=0xFF$COLOR_BASE
# export SURFACE=0xFF$COLOR_SURFACE
# export OVERLAY=0xFF$COLOR_OVERLAY
# export MUTED=0xFF$COLOR_MUTED
# export SUBTLE=0xFF$COLOR_SUBTLE
# export TEXT=0xFF$COLOR_TEXT
# export LOVE=0xFF$COLOR_LOVE
# export GOLD=0xFF$COLOR_GOLD
# export ROSE=0xFF$COLOR_ROSE
# export PINE=0xFF$COLOR_PINE
# export FOAM=0xFF$COLOR_FOAM
# export IRIS=0xFF$COLOR_IRIS
# export HIGHLIGHT_LOW=0xFF$COLOR_HIGHLIGHT_LOW
# export HIGHLIGHT_MED=0xFF$COLOR_HIGHLIGHT_MED
# export HIGHLIGHT_HIGH=0xFF$COLOR_HIGHLIGHT_HIGH
# export TRANSPARENT=0x00000000
#
# # General bar colors
# export BAR_COLOR=$BASE
# export BAR_BORDER_COLOR=$BASE
# export ICON_COLOR=$TEXT
# export LABEL_COLOR=$TEXT
# export POPUP_BACKGROUND_COLOR=$SURFACE
# export POPUP_BORDER_COLOR=$HIGHLIGHT_LOW
# export SHADOW_COLOR=$BASE
# export SPACE_BACKGROUND=$MUTED
# export CLOCK_BACKGROUND=$IRIS
# export CLOCK_COLOR=$BASE
# export SEGMENT_BACKGROUND_COLOR=$OVERLAY # The background color for segments
# export SEGMENT_BACKGROUND_HIGHLIGHT_COLOR=$SEGMENT_BACKGROUND_COLOR # The background highlight color for segments (borders, etc)
# export CONTRAST_COLOR=$SUBTLE
#
# # Item specific special colors
# export SPOTIFY_GREEN=0xFF1DB954
#
# declare -Ag WM_COLORS
# WM_COLORS=(
#   text   $TEXT
#   purple $IRIS
#   blue   $PINE
#   green  $FOAM
#   white  $TEXT
#   pink   $ROSE
# )
