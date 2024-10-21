#!/bin/bash

sketchybar --add space space_template left \
    --set space_template \
    label.drawing=off \
    drawing=off \
    updates=on \
    associated_display=1 \
    label.font="$FONT:Bold:18.0" \
    icon.font="$FONT:Bold:18.0" \
    icon.padding_right=6 \
    icon.padding_left=2 \
    icon.y_offset=2 \
    background.padding_left=0 \
    background.padding_right=1 \
    icon.background.height=2 \
    icon.background.y_offset=-13 \
    click_script="$SPACE_CLICK_SCRIPT" \
    ignore_association=on \
    \
    --clone spaces_1.label label_template \
    associated_display=1 \
    label.width=45 \
    label.align=center \
    position=left \
    drawing=on \
    \
    --clone spaces_1.idle space_template \
    --set spaces_1.idle associated_space=1 \
    icon=dev \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_1.misc space_template \
    --set spaces_1.misc associated_space=2 \
    icon=www \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_1.doc space_template \
    --set spaces_1.doc associated_space=3 \
    icon=sys \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_1.help space_template \
    --set spaces_1.help associated_space=4 \
    icon=doc \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_1.music space_template \
    --set spaces_1.music associated_space=5 \
    icon=vbox \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_2.nine space_template \
    --set spaces_2.nine associated_space=6 \
    icon=chat \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_2.code space_template \
    --set spaces_2.code associated_space=7 \
    icon=mus \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_2.tex space_template \
    --set spaces_2.tex associated_space=8 \
    icon=vid \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --clone spaces_2.web space_template \
    --set spaces_2.web associated_space=9 \
    icon=gfx \
    drawing=on \
    script="$PLUGIN_DIR/space.sh" \
    \
    --add bracket spaces_1 \
    spaces_1.label \
    spaces_1.idle \
    spaces_1.misc \
    spaces_1.doc \
    spaces_1.help \
    spaces_1.music \
    spaces_1.nine \
    spaces_1.label \
    spaces_1.code \
    spaces_1.web \
    spaces_1.tex \
    spaces_1.web
