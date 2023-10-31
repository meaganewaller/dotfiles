I use Karabiner to bind certain keys to seldom-used function keys of F17, F18, F19. Using hammerspoon I set my hyper key to F19, this allows me to still have access to all modifiers (ctrl, alt, cmd, shift).

I then use `skhd` to bind the hyper key, as well as other key combinations to various actions. Using `skhd`, I've defined specific modes where certain keycodes will be available.

## General


| Key                     | Action                                                                         |
|:------------------------|:-------------------------------------------------------------------------------|
| <kbd>caps_lock</kbd>    | Remap to <kbd>left_control</kbd>; If pressed alone, remap to <kbd>escape</kbd> |
| <kbd>left_control</kbd> | Remap to <kbd>f19</kbd>                                                        |

| Mode and Keybinding | Description                                       |
|---------------------|---------------------------------------------------|
| <kbd>default</kbd>  | Default mode.                                     |
| <kbd>resize @</kbd> | Activates `resize` mode with a custom appearance. |
| <kbd>gaps @</kbd>   | Activates `gaps` mode with a custom appearance.   |
| <kbd>layout @</kbd> | Activates `layout` mode with a custom appearance. |
| <kbd>move @</kbd>   | Activates `move` mode with a custom appearance.   |
| <kbd>launch @</kbd> | Activates `launch` mode with a custom appearance. |
| <kbd>system @</kbd> | Activates `system` mode with a custom appearance. |

| Keybinding                | Description                             |
|---------------------------|-----------------------------------------|
| <kbd>ctrl + cmd - r</kbd> | Switch to `resize` mode.                |
| <kbd>ctrl + cmd - o</kbd> | Switch to `layout` mode.                |
| <kbd>ctrl + cmd - g</kbd> | Switch to `gaps` mode.                  |
| <kbd>ctrl + cmd - m</kbd> | Switch to `move` mode.                  |
| <kbd>ctrl + cmd - a</kbd> | Switch to `launch` mode.                |
| <kbd>ctrl + cmd - x</kbd> | Switch to `system` mode.                |
| <kbd>escape</kbd>         | Return to `default` mode from any mode. |
| <kbd>return</kbd>         | Return to `default` mode from any mode. |

| Default Mode Keybindings    | Description                                         |
|-----------------------------|-----------------------------------------------------|
| <kbd>ctrl + cmd - h</kbd>   | Focus the window or display to the west.          |
| <kbd>ctrl + cmd - j</kbd>   | Focus the window or display to the south.         |
| <kbd>ctrl + cmd - k</kbd>   | Focus the window or display to the north.         |
| <kbd>ctrl + cmd - l</kbd>   | Focus the window or display to the east.          |
| <kbd>ctrl + cmd - n</kbd>   | Focus the next window in the stack.                |
| <kbd>ctrl + cmd - p</kbd>   | Focus the previous window in the stack.            |
| <kbd>hyper - 1</kbd>        | Focus space 1.                                      |
| <kbd>hyper - 2</kbd>        | Focus space 2.                                      |
| <kbd>hyper - 3</kbd>        | Focus space 3.                                      |
| <kbd>hyper - 4</kbd>        | Focus space 4.                                      |
| <kbd>hyper - 5</kbd>        | Focus space 5.                                      |
| <kbd>hyper - 6</kbd>        | Focus space 6.                                      |
| <kbd>hyper - 7</kbd>        | Focus space 7.                                      |
| <kbd>hyper - 8</kbd>        | Focus space 8.                                      |
| <kbd>hyper - 9</kbd>        | Focus space 9.                                      |
| <kbd>cmd + alt - right</kbd>| Focus the next space or the first space if at the last. |
| <kbd>cmd + alt - left</kbd> | Focus the previous space or the last space if at the first. |

| Move Mode Keybinding | Description                                   |
|----------------------|-----------------------------------------------|
| <kbd>1</kbd>         | Move the window to space 1.                  |
| <kbd>2</kbd>         | Move the window to space 2.                  |
| <kbd>3</kbd>         | Move the window to space 3.                  |
| <kbd>4</kbd>         | Move the window to space 4.                  |
| <kbd>5</kbd>         | Move the window to space 5.                  |
| <kbd>6</kbd>         | Move the window to space 6.                  |
| <kbd>7</kbd>         | Move the window to space 7.                  |
| <kbd>8</kbd>         | Move the window to space 8.                  |
| <kbd>9</kbd>         | Move the window to space 9.                  |
| <kbd>h</kbd>         | Swap the window to the west.                 |
| <kbd>l</kbd>         | Swap the window to the east.                 |
| <kbd>j</kbd>         | Swap the window to the south.                |
| <kbd>k</kbd>         | Swap the window to the north.                |
| <kbd>shift - h</kbd> | Warp the window to the west.                 |
| <kbd>shift - l</kbd> | Warp the window to the east.                 |
| <kbd>shift - j</kbd> | Warp the window to the south.                |
| <kbd>shift - k</kbd> | Warp the window to the north.                |

| Launch Mode Keybinding | Description                             |
|------------------------|-----------------------------------------|
| <kbd>f</kbd>           | Launch or focus the Kitty terminal.     |
| <kbd>return</kbd>      | Create a new Kitty terminal window.     |
| <kbd>o</kbd>           | Launch or focus Obsidian.                |
| <kbd>hyper - o</kbd>   | Launch or focus Obsidian (using Hyper). |

| Resize Mode Keybinding | Description                                         |
|------------------------|-----------------------------------------------------|
| <kbd>h</kbd>           | Resize the window to the left or increase width.  |
| <kbd>j</kbd>           | Resize the window upwards or decrease height.     |
| <kbd>k</kbd>           | Resize the window downwards or increase height.   |
| <kbd>l</kbd>           | Resize the window to the right or increase width. |
| <kbd>shift - h</kbd>   | Resize the window to the right or decrease width. |
| <kbd>shift - j</kbd>   | Resize the window downwards or increase height.   |
| <kbd>shift - k</kbd>   | Resize the window upwards or decrease height.     |
| <kbd>shift - l</kbd>   | Resize the window to the left or decrease width.  |

| Gaps Mode Keybinding | Description                                            |
|----------------------|--------------------------------------------------------|
| <kbd>k</kbd>         | Increase the gap and padding values.                   |
| <kbd>j</kbd>         | Decrease the gap and padding values.                   |
| <kbd>y</kbd>         | Set the gap and padding values to predefined values.   |
| <kbd>u</kbd>         | Remove all gaps and padding.                          |
| <kbd>i</kbd>         | Set gaps and padding to specific values.               |
| <kbd>p</kbd>         | Set gaps and padding to specific values.               |
| <kbd>o</kbd>         | Set the right padding value to a predefined value.    |
| <kbd>0x1E</kbd>      | Set the right padding value to a predefined value.    |
| <kbd>0x21</kbd>      | Set the right padding value to a predefined value.    |

| Layout Mode Keybinding | Description                                  |
|------------------------|----------------------------------------------|
| <kbd>y</kbd>           | Mirror the layout along the y-axis.         |
| <kbd>h</kbd>           | Warp the window to the west.                |
| <kbd>j</kbd>           | Warp the window to the south.               |
| <kbd>k</kbd>           | Warp the window to the north.               |
| <kbd>l</kbd>           | Warp the window to the east.                |
| <kbd>shift - h</kbd>   | Move the window to the west in a stack.     |
| <kbd>shift - k</kbd>   | Move the window to the north in a stack.    |
| <kbd>shift - j</kbd>   | Move the window to the south in a stack.    |
| <kbd>shift - l</kbd>   | Move the window to the east in a stack.     |
| <kbd>o</kbd>           | Balance the space's layout.                |
| <kbd>i</kbd>           | Set the window ratio to 0.66.              |
| <kbd>u</kbd>           | Set the window ratio to 0.33.              |
| <kbd>p</kbd>           | Set the window ratio to 0.5.               |
| <kbd>0x21</kbd>        | Set the window ratio to 0.25 (left square bracket). |
| <kbd>0x1E</kbd>        | Set the window ratio to 0.75 (right square bracket). |
| <kbd>0x27</kbd>        | Set the window ratio to 0.80 (single quote). |
| <kbd>z</kbd>           | Toggle zoom for the parent container.      |
| <kbd>0x2C</kbd>        | Toggle split for the current container.     |
| <kbd>w</kbd>           | Toggle floating mode with a 1:6:1 grid.     |
| <kbd>c</kbd>           | Toggle floating mode with a 6:8:2 grid.     |
| <kbd>t</kbd>           | Toggle floating mode and sticky state.      |
| <kbd>b</kbd>           | Set the space layout to bsp.                |
| <kbd>f</kbd>           | Set the space layout to float.              |
| <kbd>s</kbd>           | Set the space layout to stack.              |

## Kitty

| Keybinding                     | Description                                          |
|--------------------------------|------------------------------------------------------|
| <kbd>kitty_mod + enter</kbd>   | No-op (prevents accidental window creation).        |
| <kbd>cmd + enter</kbd>         | No-op (prevents accidental window creation).        |
| <kbd>kitty_mod + w</kbd>       | Quit Kitty.                                          |
| <kbd>kitty_mod + v</kbd>       | Paste from clipboard.                               |
| <kbd>kitty_mod + /</kbd>       | Launch search.py in a horizontal split.            |
| <kbd>ctrl + a > /</kbd>        | Launch fzf for custom hints.                        |
| <kbd>ctrl + a > ?</kbd>        | Launch custom-hints.sh for custom hints.            |
| <kbd>kitty_mod + f5</kbd>      | Reload Kitty configuration.                         |
| <kbd>kitty_mod + p</kbd>       | Open a new tab.                                      |
| <kbd>kitty_mod + i</kbd>       | Enable Unicode input.                               |
| <kbd>kitty_mod + c</kbd>       | Copy to clipboard.                                  |
| <kbd>kitty_mod + v</kbd>       | Paste from clipboard.                               |
| <kbd>kitty_mod + b</kbd>       | Paste from selection.                               |
| <kbd>kitty_mod + equal</kbd>   | Increase font size.                                 |
| <kbd>kitty_mod + minus</kbd>   | Decrease font size.                                 |
| <kbd>kitty_mod + escape</kbd>  | Reset font size.                                    |
| <kbd>kitty_mod + \</kbd>       | Set font size to 24.                                |
| <kbd>kitty_mod + up</kbd>      | Scroll line up.                                     |
| <kbd>kitty_mod + down</kbd>    | Scroll line down.                                   |
| <kbd>kitty_mod + u</kbd>       | Scroll page up.                                     |
| <kbd>kitty_mod + d</kbd>       | Scroll page down.                                   |
| <kbd>kitty_mod + home</kbd>    | Scroll to the top.                                  |
| <kbd>kitty_mod + end</kbd>     | Scroll to the bottom.                               |
| <kbd>kitty_mod + right</kbd>   | Scroll to the next prompt.                          |
| <kbd>kitty_mod + left</kbd>    | Scroll to the previous prompt.                      |
| <kbd>F7</kbd>                  | Rotate the current layout.                          |
| <kbd>shift + up</kbd>          | Move the active window up.                          |
| <kbd>shift + left</kbd>        | Move the active window left.                        |
| <kbd>shift + right</kbd>       | Move the active window right.                       |
| <kbd>shift + down</kbd>        | Move the active window down.                        |
| <kbd>ctrl + a > k</kbd>        | Focus on the window above the active window.        |
| <kbd>ctrl + a > j</kbd>        | Focus on the window below the active window.        |
| <kbd>ctrl + a > h</kbd>        | Focus on the window to the left of the active window. |
| <kbd>ctrl + a > l</kbd>        | Focus on the window to the right of the active window. |
| <kbd>kitty_mod + x</kbd>       | Close the active window.                            |
| <kbd>ctrl + a >;</kbd>         | Detach the active window.                           |
| <kbd>ctrl + a >]</kbd>         | Focus on the next window.                           |
| <kbd>ctrl + a >[</kbd>         | Focus on the previous window.                       |
| <kbd>kitty_mod + period</kbd>  | Move the active window forward.                     |
| <kbd>kitty_mod + comma</kbd>   | Move the active window backward.                    |
| <kbd>ctrl + a >l</kbd>        | Open a new tab.                                      |
| <kbd>ctrl + a >h</kbd>        | Switch to the previous tab.                         |
| <kbd>ctrl + a >t</kbd>        | Open a new tab with the last reported directory.     |
| <kbd>ctrl + a >c</kbd>        | Open a new tab with the last reported directory.     |
| <kbd>ctrl + a >,</kbd>        | Set the tab title.                                   |
| <kbd>ctrl + a >enter</kbd>    | Toggle maximized state.                             |
| <kbd>ctrl + a >shift + enter</kbd> | Toggle layout to 'stack'.                        |
| <kbd>ctrl + a >n + l</kbd>    | Cycle through layouts.                              |
| <kbd>kitty_mod + t</kbd>      | Launch a horizontal split.                         |
| <kbd>ctrl + a >minus</kbd>    | Launch a horizontal split.                         |
| <kbd>ctrl + a >shift + minus</kbd> | Launch a horizontal split.                    |
| <kbd>ctrl + a >backslash</kbd> | Launch a vertical split.                          |
| <kbd>ctrl + a >shift + backslash</kbd> | Launch a vertical split.                  |
| <kbd>ctrl + a >ctrl + s</kbd> | Swap the split axis.                                |
| <kbd>ctrl + a >z</kbd>        | Zoom toggle.                                        |
| <kbd>ctrl + a >t</kbd>        | Change themes.                                     |
| <kbd>ctrl + a >q</kbd>        | Focus on the visible window.                       |
| <kbd>ctrl + a >1</kbd>        | Switch to tab 1.                                   |
| <kbd>ctrl + a >2</kbd>        | Switch to tab 2.                                   |
| <kbd>ctrl + a >3</kbd>        | Switch to tab 3.                                   |
| <kbd>ctrl + a >4</kbd>        | Switch to tab 4.                                   |
| <kbd>ctrl + a >5</kbd>        | Switch to tab 5.                                   |
| <kbd>ctrl + a >6</kbd>        | Switch to tab 6.                                   |
| <kbd>ctrl + a >7</kbd>        | Switch to tab 7.                                   |
| <kbd>ctrl + a >8</kbd>        | Switch to tab 8.                                   |
| <kbd>ctrl + a >9</kbd>        | Switch to tab 9.                                   |
| <kbd>ctrl + a >0</kbd>        | Switch to tab 10.                                  |
| <kbd>ctrl + a >shift + s</kbd> | Dump Kitty session.                                |
| <kbd>ctrl + q</kbd>           | Close the OS window.                                |


## Neovim

### General Keybindings

| Keybinding                      | Description                                          |
|---------------------------------|------------------------------------------------------|
| `;w`                            | Write Buffer.                                        |
| `;c`                            | Close Buffer.                                       |
| `;C`                            | Close Tab.                                          |
| `;q`                            | Close Window.                                       |
| `;Q` or `ZQ`                   | Close Application.                                  |
| `<Tab>` in Normal Mode         | Indent or Enter Insert Mode (depending on context). |
| `<Shift-Tab>` in Normal Mode   | Outdent.                                            |
| `<F6>`                          | Print Filetype and Buffertype information.          |
| `<F7>`                          | Print the number of selected columns.              |
| `<C-F5>` or `<F29>`            | Toggle Command Line Height between 0 and 1.         |
| `<kEnter>`                     | Enter.                                              |
| `<leader>` + `,u`               | Open the Utils configuration.                       |
| `<leader>` + `,a`               | Open the Autocmds configuration.                   |
| `<leader>` + `,o`               | Open the Options configuration.                     |
| `<leader>` + `,w`               | Open the Which-Key configuration.                  |
| `<leader>` + `fn`               | Create a new file.                                  |
| `<leader>` + `fw`               | Write the buffer without formatting.               |
| `<leader>` + `fW`               | Write the buffer with sudo (requires password).    |
| `<leader>` + `fo`               | Open the file with the system's default app.       |
| `<leader>` + `fy`               | Yank the relative path of the active file.         |
| `<leader>` + `fY`               | Yank the full path of the active file.             |
| `<leader>` + `ts`               | Toggle spellcheck.                                  |
| `<leader>` + `tw`               | Toggle whitespace characters display.               |
| `<leader>` + `tl`               | Toggle line wrapping.                               |
| `<C-n>` in Command Line Mode   | Move to the next related command history item.     |
| `<C-p>` in Command Line Mode   | Move to the previous related command history item. |
| `/`                             | Search the selected text.                          |
| `<C-c>` or `<Esc>` in Normal Mode | Clear search highlighting.                         |
| `<C-a>` in Normal Mode         | Increment the number under the cursor.             |
| `<C-x>` in Normal Mode         | Decrement the number under the cursor.             |
| `<leader>` + "`R`"              | Reset the terminal.                                 |
| `<leader>` + "<C-c>"           | Escape key.                                         |
| `<SPACE>`                      | Create an undo breakpoint.                         |
| `gV`                            | Select the last pasted text.                      |
| `<S-Right>` or `<S-Left>`      | Scroll the viewport horizontally.                   |
| `<S-ScrollWheelDown>` or `<S-ScrollWheelUp>` | Scroll the viewport horizontally with the mouse. |
| `<C-e>` or `<C-y>`             | Scroll up or down with increased distance.        |
| `<C-w>1`, `<C-w>2`, `<C-w>3`, `<C-w>4`, `<C-w>5` | Quick window switch.                           |
| `<C-w>c`                        | Close the current window.                          |
| `<C-w>q`                        | Quit the current window.                           |
| `<C-w>b`                        | Set the window width to the color column.         |
| `<C-Tab>`                       | Switch to the next tab.                            |
| `<C-S-Tab>`                    | Switch to the previous tab.                        |
| `<C-w>tc`                       | Close the current tab.                            |
| `<C-w>tC`                       | Close all other tabs.                             |
| `<C-w>tt`                       | Create a new tab.                                 |
| `o`                             | Insert a new line with appropriate indentation.    |
| `O`                             | Insert a new line above with appropriate indentation. |
| `<CR>`                          | Insert a new line with appropriate indentation.    |
| `<Esc>` in Insert Mode         | Clear empty lines.                                  |
| `"<S-d>` in Insert Mode        | Clear empty lines.                                  |
| `<C-a>` in Visual Mode         | Increment numbers within the selection.            |
| `<C-x>` in Visual Mode         | Decrement numbers within the selection.            |
| `<S-2-ScrollWheelDown>`, `<S-3-ScrollWheelDown>`, `<S-4-ScrollWheelDown>`, `<S-2-ScrollWheelUp>`, `<S-3-ScrollWheelUp>`, `<S-4-ScrollWheelUp>` | Fix mouse scrolling with acceleration. |
| `<kEnter>`                     | Enter.                                              |
| `<leader>` + "`R`"              | Reset the terminal.                                 |
| `<C-c>`                         | Escape key.                                         |
| `gV`                            | Select the last pasted text.                      |
| `<S-Right>` or `<S-Left>`      | Scroll the viewport horizontally.                   |
| `<S-ScrollWheelDown>` or `<S-ScrollWheelUp>` | Scroll the viewport horizontally with the mouse. |
| `<C-e>` or `<C-y>`             | Scroll up or down with increased distance.        |
| `<C-w>1`, `<C-w>2`, `<C-w>3`, `<C-w>4`, `<C-w>5` | Quick window switch.                           |
| `<C-w>c`                        | Close the current window.                          |
| `<C-w>q`                        | Quit the current window.                           |
| `<C-w>b`                        | Set the window width to the color column.         |
| `<C-Tab>`                       | Switch to the next tab.                            |
| `<C-S-Tab>`                    | Switch to the previous tab.                        |
| `<C-w>tc`                       | Close the current tab.                            |
| `<C-w>tC`                       | Close all other tabs.                             |
| `<C-w>tt`                       | Create a new tab.                                 |
| `o`                             | Insert a new line with appropriate indentation.    |
| `O`                             | Insert a new line above with appropriate indentation. |
| `<CR>`                          | Insert a new line with appropriate indentation.    |
| `<Esc>` in Insert Mode         | Clear empty lines.                                  |
| `"<S-d>` in Insert Mode        | Clear empty lines.                                  |
| `<C-a>` in Visual Mode         | Increment numbers within the selection.            |
| `<C-x>` in Visual Mode         | Decrement numbers within the selection.            |




