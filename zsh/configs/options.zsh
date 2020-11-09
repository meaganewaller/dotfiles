setopt no_beep
setopt interactive_comments

setopt auto_cd             # go to dirs without cd (as long as its not a command on your path)
setopt cdablevarS          # if arg to cd is the name of a param whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups   # dont push multiple copies of the same directory onto the directory stack

setopt extendedglob      # treat #, ~, and ^ as part of patterns for filename generation

setopt append_history         #allow multiple terminal sessions to all append to one zsh command history
setopt extended_history       #save timestamp of command and duration
setopt inc_append_history     #add commands as they're typed, don't wait until shell exit
setopt hist_expire_dups_first #when trimming history, lose oldest dupes first
setopt hist_ignore_dups       #do not write dupe events to history
setopt hist_ignore_space      #remove command line from history list when first char on line is a space
setopt hist_find_no_dups      #when searching history don't display results already cycled through twice
setopt hist_reduce_blanks     #remove extra blanks from each command line being added to history
setopt hist_verify            #dont execute, just expand history
setopt share_history          #imports new commands and appends typed commands to history

setopt always_to_end    #when completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu        #show completion menu on successive tab press. needs unsetopt menu_complete to work
setopt auto_name_dirs   #any param that is set to the absolute name of a directory immediately becomes a new for the directory
setopt complete_in_word #allow completion from within a word/phrase
unsetopt menu_complete  #do not autoselect the first completion entry

setopt correct    #spelling correction for commands
setopt correctall #spelling correction for arguments

setopt prompt_subst      #enable param expansion, command substitution, and arithmetic expansion in prompt
setopt transient_rprompt #only show the rprompt on the current prompt

setopt multios #perform implicit tees or cats when multiple redirections are attempted
unsetopt nomatch #allow [ or ] where ever you want.