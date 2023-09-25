#!/usr/bin/env fish

function now -d "Print the current date and time"
  set dayOfMonth (date '+%d')

  # Choose postfix
  switch "$dayOfMonth"
    case 1
      set postfix "st"
    case 2
      set postfix "nd"
    case 3
      set postfix "rd"
    case '*'
      set postfix "th"
  end

  # Generate date string
  set myDate (date "+%A, %B %d$postfix")

  echo -n "$myDate "
  date "+%I:%M:%S"
end
