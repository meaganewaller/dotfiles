#!/usr/bin/env fish

function draw
  wezterm icat file
  exit 1
end

set file $argv[1]
set w $argv[2]
set h $argv[3]
set x $argv[4]
set y $argv[5]

switch (file -Lb --mime-type $file)
case "image/*"
    draw $file
case '*'
    bat --paging=never --color=always $file
end
