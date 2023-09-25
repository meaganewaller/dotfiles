# Kitty

## Key Bindings

Below is the keymap configuration for the Kitty terminal. This keymap defines various shortcuts and keybindings for performing actions within the terminal.

### Keymap Configuration

| Key                           | Action                                                    |
|:------------------------------|:----------------------------------------------------------|
| <kbd>ctrl+shift+enter</kbd>   | Change font size to 24                                    |
| <kbd>ctrl+a></kbd>            | Launch FZF for custom processing                          |
| <kbd>ctrl+a>space</kbd>       | Launch custom hints with alphabet and processing script   |
| <kbd>ctrl+a>i>u</kbd>         | Insert URL                                                |
| <kbd>ctrl+a>i>w</kbd>         | Insert word                                               |
| <kbd>ctrl+a>i>l</kbd>         | Insert line                                               |
| <kbd>ctrl+a>i>p</kbd>         | Insert path                                               |
| <kbd>ctrl+a>i>h</kbd>         | Insert hash                                               |
| <kbd>ctrl+a>y>u</kbd>         | Copy URL to clipboard                                     |
| <kbd>ctrl+a>y>w</kbd>         | Copy word to clipboard                                    |
| <kbd>ctrl+a>y>l</kbd>         | Copy line to clipboard                                    |
| <kbd>ctrl+a>y>p</kbd>         | Copy path to clipboard                                    |
| <kbd>ctrl+a>y>h</kbd>         | Copy hash to clipboard                                    |
| <kbd>ctrl+a>x</kbd>           | Close current window                                      |
| <kbd>ctrl+a>;</kbd>           | Detach current window (ask for confirmation)              |
| <kbd>ctrl+a>]</kbd>           | Move to next window                                       |
| <kbd>ctrl+a>[</kbd>           | Move to previous window                                   |
| <kbd>ctrl+a>period</kbd>      | Move window forward                                       |
| <kbd>ctrl+a>comma</kbd>       | Move window backward                                      |
| <kbd>ctrl+a>l</kbd>           | Switch to next tab                                        |
| <kbd>ctrl+a>h</kbd>           | Switch to previous tab                                    |
| <kbd>ctrl+a>t</kbd>           | Launch a new tab with the last reported working directory |
| <kbd>ctrl+a>c</kbd>           | Launch a new tab with the last reported working directory |
| <kbd>ctrl+a>,</kbd>           | Set tab title                                             |
| <kbd>ctrl+a>enter</kbd>       | Toggle window maximized                                   |
| <kbd>ctrl+a>shift+enter</kbd> | Toggle layout stack                                       |
| <kbd>ctrl+a>n+l</kbd>         | Switch to the next layout                                 |
| <kbd>ctrl+a>t</kbd>           | Launch a new horizontal split                             |
| <kbd>ctrl+a>k</kbd>           | Open a new terminal window                                |

Below is the keymap configuration for splitting windows and managing layouts in Kitty terminal.

| Key                               | Action                                                                |
|:----------------------------------|:----------------------------------------------------------------------|
| <kbd>ctrl+a>minus</kbd>           | Create a new horizontal split, placing windows one above the other    |
| <kbd>ctrl+a>shift+minus</kbd>     | Create a new horizontal split                                         |
| <kbd>ctrl+a>backslash</kbd>       | Create a new vertical split, placing windows side by side             |
| <kbd>ctrl+a>shift+backslash</kbd> | Create a new vertical split                                           |
| <kbd>ctrl+a>ctrl+s</kbd>          | Create a new split with adaptive placement based on window dimensions |
| <kbd>F7</kbd>                     | Rotate the current window, swapping its split axis                    |
| <kbd>shift+up</kbd>               | Move the active window up                                             |
| <kbd>shift+left</kbd>             | Move the active window left                                           |
| <kbd>shift+right</kbd>            | Move the active window right                                          |
| <kbd>shift+down</kbd>             | Move the active window down                                           |
| <kbd>ctrl+a>k</kbd>               | Switch focus to the neighboring window above                          |
| <kbd>ctrl+a>j</kbd>               | Switch focus to the neighboring window below                          |
| <kbd>ctrl+a>h</kbd>               | Switch focus to the neighboring window to the left                    |
| <kbd>ctrl+a>l</kbd>               | Switch focus to the neighboring window to the right                   |
| <kbd>alt+n</kbd>                  | Resize the active window narrower                                     |
| <kbd>alt+w</kbd>                  | Resize the active window wider                                        |
| <kbd>alt+u</kbd>                  | Resize the active window taller                                       |
| <kbd>alt+d</kbd>                  | Resize the active window shorter (3 times)                            |
| <kbd>ctrl+home</kbd>              | Reset all windows in the tab to default sizes                         |
| <kbd>ctrl+a>z</kbd>               | Toggle zoom for the active window                                     |
| <kbd>ctrl+a>t</kbd>               | Open the Kitty themes menu                                            |
| <kbd>ctrl+a>q</kbd>               | Focus on the visible window                                           |
| <kbd>ctrl+a>1</kbd>               | Go to tab 1                                                           |
| <kbd>ctrl+a>2</kbd>               | Go to tab 2                                                           |
| <kbd>ctrl+a>3</kbd>               | Go to tab 3                                                           |
| <kbd>ctrl+a>4</kbd>               | Go to tab 4                                                           |
| <kbd>ctrl+a>5</kbd>               | Go to tab 5                                                           |
| <kbd>ctrl+a>6</kbd>               | Go to tab 6                                                           |
| <kbd>ctrl+a>7</kbd>               | Go to tab 7                                                           |
| <kbd>ctrl+a>8</kbd>               | Go to tab 8                                                           |
| <kbd>ctrl+a>9</kbd>               | Go to tab 9                                                           |
| <kbd>ctrl+a>0</kbd>               | Go to tab 10                                                          |
| <kbd>ctrl+a>shift+s</kbd>         | Dump the current session to a file (requires custom script)           |
| <kbd>ctrl+q</kbd>                 | Close the outermost window or quit the terminal                       |

## Mouse Configuration Keymap

Below is the keymap configuration for mouse actions in Kitty terminal.

### Mouse Configuration

| Action                                   | Key Combination                        | Description                                                             |
|:-----------------------------------------|:---------------------------------------|:------------------------------------------------------------------------|
| Open Link with `open`                     | <kbd>cmd+left</kbd>                   | Release ungrabbed mouse and pass the selection to `/usr/bin/open`     |
| Click Selection Link or Prompt            | <kbd>cmd+left</kbd> (click)           | Handle click action for grabbed and ungrabbed mouse                    |
| Disable Left-Click for Link Opening      | <kbd>left</kbd> (click)               | Disable left-click action to prevent accidental link opening           |
| Click Selection Link or Prompt            | <kbd>ctrl+left</kbd> (click)          | Handle click action for grabbed and ungrabbed mouse                    |
| Start Mouse Selection (Ctrl+Left Press)  | <kbd>ctrl+left</kbd> (press)          | Activate mouse selection in normal mode                                 |
| Copy to Clipboard (Right Mouse Press)     | <kbd>right</kbd> (press)              | Copy the selected text to the clipboard in ungrabbed mode              |
