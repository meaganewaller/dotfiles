#!/usr/bin/env bash

get_format() {
    local i=0
    local index="$2"
    tmux lsw -F "#{$1}" | while read line; do
        if [[ $i == $index ]]; then
            echo $line
            return 0
        fi
        i="$(( $i + 1 ))"
    done
    return 1
}

TARGET_INDEX="$1"

WINDOW_INDEX="$( get_format window_index $TARGET_INDEX )"
WINDOW_NAME="$( get_format window_name $TARGET_INDEX )"
PANE_START_COMMAND="$( get_format pane_start_command $TARGET_INDEX )"
PANE_CURRENT_COMMAND="$( get_format pane_current_command $TARGET_INDEX )"
PANE_INDEX="$( get_format pane_index $TARGET_INDEX )"
WINDOW_PANES="$( get_format window_panes $TARGET_INDEX )"
PANE_CURRENT_PATH="$( get_format pane_current_path $TARGET_INDEX )"

window_title=''
if [[ $WINDOW_NAME != $PANE_START_COMMAND ]] && \
    [[ $WINDOW_NAME != $PANE_CURRENT_COMMAND ]]; then
    # Window name is specified
    window_title="$WINDOW_NAME"
else
    # Show PWD
    # Although *highly* unlikely, make sure there's no # in $HOME
    if [[ $HOME == *#* ]]; then
        # If there's also a ! in $HOME, let's just give up :-P
        sep='!'
    else
        sep='#'
    fi
    # Then replace $HOME with ~
    home_replaced="$( echo $PANE_CURRENT_PATH | sed -e "s${sep}^${HOME}${sep}~${sep}" )"
    window_title="$( basename $home_replaced )/"
fi

printf "%-15s" "$window_title" | cut -c 1-15
