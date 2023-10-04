<div align="justify">
<div align="center">

<pre align="center">
╔════════════════ °❀•°✮°•❀° ═════════════════╗<br>
✧･ﾟ:*<a href="#-setup">Setup</a> ✧ <a href="#--key-bindings">Keybinds</a> ✧ <a href="https://github.com/meaganewaller/dotfiles/wiki/Gallery">Gallery</a> ✧ <a href="#-guides">Guides</a>*:･ﾟ✧ <br>
╚════════════════ °❀•°✮°•❀° ═════════════════╝
</pre>

<!-- <p align="center"> -->
<!-- <a href="#setup"><img width="150px" style="padding: 0 10px;" src="assets/setup.png"></a> -->
<!-- <a href="https://github.com/meaganewaller/dotfiles/wiki"><img width="150px" style="padding: 0 10px;" src="assets/wiki.png"></a> -->
<!-- <a href="https://github.com/meaganewaller/dotfiles/wiki/Gallery"><img width="150px" style="padding: 0 10px;" src="assets/gallery.png"></a> -->
<!-- <a href="https://github.com/meaganewaller/dotfiles/wiki/Keybinds"><img width="150px" style="padding: 0 10px;" src="assets/keybinds.png"></a> -->
<!-- </p> -->

<pre align="center">
  ┌┬┐┬ ┬┌─┐┬─┐┌─┐┌─┐  ┌┐┌┌─┐  ┌─┐┬  ┌─┐┌─┐┌─┐  ┬  ┬┬┌─┌─┐
   │ ├─┤├┤ ├┬┘├┤ └─┐  ││││ │  ├─┘│  ├─┤│  ├┤   │  │├┴┐├┤
   ┴ ┴ ┴└─┘┴└─└─┘└─┘  ┘└┘└─┘  ┴  ┴─┘┴ ┴└─┘└─┘  ┴─┘┴┴ ┴└─┘
  ° ˛ ° ˚*_Π_____*☽*˚ ˛
  ✩ ˚˛˚*   /______/__＼。✩˚ ˚˛
  ˚ ˛˚˛˚｜ 田田｜門｜ ˚ ˚
</pre>

# [![repo visits](https://badges.pufler.dev/visits/meaganewaller/dotfiles?style=flat-square&label=&color=000000&logo=github&logoColor=white&labelColor=000000)](#)

</div>

# 🌷 <sup><sub><samp> welcome to my dotfiles! </samp></sub></sup>

<a href="">
<picture>
    <source media="(prefers-color-scheme: dark)" alt="Screenshot of my desktop" align="right" width="400px" srcset=""/>
     <img alt="Screenshot of my desktop" align="right" width="400px" src="assets/dotfiles.png"/>
</picture>
</a>

My fully automated dev environment is built to ✨spark joy✨. Aesthetics **and** performance are prioritized.

## Quick details about my setup

### macOS

- **Operating System**: [macOS Monterey](https://www.apple.com/by/macos/monterey/)
- **Automation Tool**: [hammerspoon](https://github.com/Hammerspoon/hammerspoon) ([config](/tools/misc/hammerspoon))
- **Window Manager**: [yabai](https://github.com/koekeishiya/yabai) ([config](/wm/yabai))
- **Terminal Emulator**: [kitty](https://sw.kovidgoyal.net/kitty/) ([config](/terminals/kitty))
- **Shell**: [fish](https://fishshell.com/) ([config](/shells/fish))
- **Editor**: [neovim](http://neovim.io/) ([config](/editors/nvim))
- **Browser**: [Brave](https://brave.com/)
- **App Launcher**: [Raycast](https://raycast.com) ([config](/launchers/raycast))
- **Keyboard Customizer**: [Karabiner](https://karabiner-elements.pqrs.org/) ([config](/tools/keys/karabiner))
- **Menubar**: [Sketchybar](https://felixkratz.github.io/SketchyBar/config/bar) ([config](/statusbars/sketchybar))

<h1>
  <a href="#---------1">
    <img alt="" align="right" src="https://img.shields.io/github/commit-activity/m/meaganewaller/dotfiles/ng?style=flat-square&label=&color=000000&logo=gitbook&logoColor=white&labelColor=000000"/>
  </a>
</h1>

<br>

## 🌱 <samp>SETUP</samp>

I use [dotbot](https://github.com/anishathalye/dotbot) to bootstrap my dotfiles. This allows me to keep a versioned directory of all my config files that are symlinked into place via a command. This lets me share my files with you.

### 🧪🔬<samp> EXPERIMENTAL & NOT GUARANTEED</samp> 💁‍♀️

I update this constantly with poor git habits. There are no guarantees of stability, working on any machine but my own (and sometimes, tbh not even my own), or a "productive" "enjoyable" "experience".

> It's highly recommended that you dig into the configs yourself. It's _not_ the best habit to install mine--A Stranger's--shell scripts. But also, you do you.

### <samp>INSTALLING</samp>

### :blossom: ‎ <samp>INSTALLATION ([DEPENDENCIES](./REPOLOGY.md))</samp>

Ready to dive into the deep end? Here's how to get started:

**1. Clone the Dotfiles Repository:**

```sh
💲 cd ~
💲 git clone git@github.com:meaganewaller/dotfiles.git ~/.dotfiles
```

Congratulations, you've just initiated the journey into my digital realm. The rabbit hole awaits.

**2. Navigate to the Dotfiles Directory:**

```sh
💲 cd ~/.dotfiles
```

Welcome to the rabbit hole. You can't go back now. This is where the magic happens. And the magic is a Rakefile.

**4. Backup Your Existing Config:**

```sh
💲 rake backup
💲 rake # alias for rake backup
```

Ok, so maybe you can go back. But only if you've backed up your existing configs. This command will copy any existing dotfiles into a `~/.dotfiles-backup` directory. You can use this to restore your original configs if you decide to go back to the way things were.

**5. Run the Installation Script:**

```sh
💲 rake install
```

This is where the real fun begins. Buckle up as the configurations are symlinked into place, packages are installed, and defaults are set. This may take a while.

**6. Updating an Existing Installation:**

```sh
💲 rake update
```

Already in the rabbit hole? Keep your configs up to date with the latest changes by running the `up` command.

<hr style="border: 1px dashed pink" />

now you're all set to explore the depths of my dotfiles. enjoy the ride. just remember, with great customization comes great responsibility. or whatever uncle ben said.

## <samp>✨TOOLS & RESOURCES</samp>

allow me to introduce you to my trusted accomplices. keep in mind that my loyalty to any given tool is fickle and subject to change at any moment a shiny new one catches my eye. but for now, here's the current ensemble:

### kitty terminal emulator

- **github**: [kitty](https://github.com/kovidgoyal/kitty)
- **description**: the kitty terminal emulator is the cat's meow when it comes to terminal experiences. it's fast, it's customizable, and it's got a cute name with a cute icon. what more could you want? it's purr-fectly suited for my daily coding antics.

### neovim code editor

- **website:** [neovim](https://neovim.io/)
- **description:** neovim is my code sanctuary. it's like a swiss army knife for text editing but with more shortcuts and fewer corkscrews. vim enthusiasts, rejoice!

### fish shell

- **website:** [fish](https://fishshell.com/)
- **description:** the Fish shell is my trusty sidekick in the command-line world. it's user-friendly, intuitive, and always ready to lend a helping fin.

### asdf version manager

- **website:** [asdf](https://asdf-vm.com/)
- **description:** asdf is the wizard behind the curtain, managing my development environment with ease. it's like having a magic wand for installing and switching between programming languages.

### sketchybar menubar

- **github:** [sketchybar](https://github.com/FelixKratz/SketchyBar)
- **description:** like a chameleon for your desktop, sketchybar changes hues to match my mood and serves as a trusty heads-up display for key information.

### skhd shortcut daemon

- **github:** [skhd](https://github.com/koekeishiya/skhd)
- **description:** a silent conductor orchestrating my custom keyboard shortcuts, working tirelessly behind the scenes.

### homebrew package manager

- **website:** [homebrew](https://brew.sh/)
- **description:** homebrew is the bartender of my system, serving up all the software i need with a simple command. it keeps my system well-hydrated with the latest apps.

### fira code nerd font

- **github:** [fira code nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/firacode)
- **description:** fira code nerd font is the font of choice for my code. it's like the perfect pair of jeans—it just fits right and makes everything look good.

### ibm plex typeface

- **website:** [ibm plex](https://www.ibm.com/plex/)
- **description:** ibm plex is my typographic muse. it's clean, modern, and adds a touch of class to my monitor. i pretty much only use it for italics.

### bigblue terminal font

- **website:** [bigblue terminal](https://int10h.org/blog/2015/12/bigblue-terminal-oldschool-fixed-width-font/)
- **description:** bigblue terminal font takes me back to the good old days of computing. it's retro, it's fixed-width, and it's just plain cool.

### hammerspoon automation tool

- **website:** [hammerspoon](https://www.hammerspoon.org/)
- **description:** hammerspoon is my digital butler, automating tasks and making my life easier. it's like having a personal assistant in code form.

### karabiner elements keyboard customizer

- **github:** [karabiner elements](https://github.com/tekezo/Karabiner-Elements)
- **description:** karabiner elements is my key manipulator, shaping keyboard behaviors to adapt effortlessly to different layouts and key combinations. it's a versatile tool for customizing key functions to suit my needs.

now that you've met the crew, feel free to explore their individual quirks and see how they contribute to the symphony of my digital life.

## 🌻 <samp> KEY BINDINGS</samp>

I use karabiner to bind certain keys to seldom-used function keys of F17, F18, F19. Using hammerspoon I set my hyper key to F18, this allows me to still have access to all modifiers (ctrl, alt, cmd, shift)[^2].
I then use skhd to bind the hyper key, as well as other key combinations to various actions. Using skhd, I've defined specific modes where certain keycodes will be available.

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

[^2]: Evan Travers' [blog post about a Better Hyper Key](https://evantravers.com/articles/2020/06/08/hammerspoon-a-better-better-hyper-key/) is the inspiration behind this.

## 🌻 <samp> GUIDES</samp>

to get the most out of my dotfiles, i recommend reading through the guides below. they'll help you understand how everything works and how to customize it to your liking.

- [**hammerspoon guide**](https://github.com/meaganewaller/dotfiles/wiki/Hammerspoon-Guide)
- [**kitty guide**](https://github.com/meaganewaller/dotfiles/wiki/Kitty-Guide)
- [**neovim guide**](https://github.com/meaganewaler/dotfiles/wiki/Neovim-Guide)
- [**fish guide**](https://github.com/meaganewaler/dotfiles/wiki/Neovim-Guide)
- [**sketchybar guide**](https://github.com/meaganewaler/dotfiles/wiki/Neovim-Guide)
- [**skhd guide**](https://github.com/meaganewaler/dotfiles/wiki/Neovim-Guide)
- [**homebrew guide**](https://github.com/meaganewaler/dotfiles/wiki/Neovim-Guide)
- [**karabiner guide**](https://github.com/meaganewaler/dotfiles/wiki/Neovim-Guide)

## 🌻 <samp> CREDITS</samp>

TODO: add credits

## 🤝 <samp> CONTRIBUTING</samp>

thank you for showing interest in contributing to my dotfiles! these configurations are deeply personal, reflecting my own quirks and preferences, but i'm always open to valuable suggestions and improvements.

### ❗️ note

these dotfiles are primarily tailored to my specific needs and workflow. while i may not be actively seeking random contributions, your insights and ideas are highly appreciated. if you come across something that
could be enhanced or have a suggestion that could benefit a broader audience, please don't hesitate to share it.

### 💡 suggesting changes

if you have an idea for an improvement or a suggestion, feel free to open an issue outlining the details. i'll review it, and if it aligns with the goals of these dotfiles,
we can turn it into an actionable issue that welcomes contributions.

please be clear and concise in your proposals, and let's work together to make these dotfiles even more useful for everyone :sparkles:

### 🐛 reporting bugs & troubleshooting

if you encounter a bug or issue with these dotfiles, please open an issue with the details. i'll review it, and if it's a bug, we'll queue it for squashing.

some issues may be related to the tools and resources used in these dotfiles. if that's the case, i'll do my best to help you troubleshoot and resolve the issue.
in lieu of opening an issue, there are some common troubleshooting steps you can take:

- **check the documentation:** if you're having trouble with a specific tool or resource, check the documentation to see if it addresses your issue.
- **check the wiki:** i've documented some common issues and solutions in the wiki. check there to see if your issue is covered.
- **check the source:** if you're comfortable with the tools and resources used in these dotfiles, you can check the source code to see if you can find the issue yourself.
- **check the internet:** if all else fails, try searching the internet for a solution. you'd be surprised how many people have run into the same issues you're facing.

## 📌 <samp> future plans</samp>

these dotfiles are a work in progress, and i'm always looking for ways to improve them. here are some of the things i'm planning to add in the future:

- [ ] add more documentation
- [ ] add more guides
- [ ] add more screenshots
- [ ] add more tools & resources

</div>
