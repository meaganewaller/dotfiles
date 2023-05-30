#!/usr/bin/env bash

args=()
case "$MODE" in
  "focus")
    args+=(--set window.skhd label="􀋦 " label.align=center label.drawing=on)
    ;;
  "warp")
    args+=(--set window.skhd label="􀬑 " label.align=center label.drawing=on)
    ;;
  "resize")
    args+=(--set window.skhd label="􀄾 " label.align=center label.drawing=on)
    ;;
  "prefix")
    args+=(--set window.skhd label="􀆿 " label.align=center label.drawing=on)
    ;;
  *)
    args+=(--set window.skhd label="􀥳 " label.align=center label.drawing=on)
    ;;
esac

sketchybar -m "${args[@]}"
