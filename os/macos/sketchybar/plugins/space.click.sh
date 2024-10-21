#!/usr/bin/env zsh

space_id=$NAME
space_id=${space#*space_}

yabai -m space --focus $space_id
