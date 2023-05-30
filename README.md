<div align="justify">
<div align="center">


<pre align="center">
╔════════════════ °❀•°✮°•❀° ═════════════════╗<br>
✧･ﾟ:* <a href="#-setup">Setup</a> ✧ <a href="#--key-bindings">Keybinds</a> ✧ <a href="https://github.com/meaganewaller/dotfiles/wiki/Gallery">Gallery</a> ✧ <a href="#-guides">Guides</a> *:･ﾟ✧ <br>
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
° ˛ ° ˚* _Π_____*☽*˚ ˛
✩ ˚˛˚*   /______/__＼。✩˚ ˚˛
˚ ˛˚˛˚｜ 田田｜門｜ ˚ ˚
´´ ̛ ̛ ´´ ´´ ´´ ̛ ̛ ´´ ´´ ´´ ̛ ̛ ´´ ´´
</pre>

<h1>
  <a href="#--------">
    <img alt="" align="right" src="https://badges.pufler.dev/visits/meaganewaller/dotfiles?style=flat-square&label=&color=000000&logo=github&logoColor=white&labelColor=000000"/>
  </a>
</h1>

</div>

### 🌷 <sup><sub><samp> welcome to my dotfiles! </samp></sub></sup>

<a href="">
<picture>
    <source media="(prefers-color-scheme: dark)" alt="Screenshot of my desktop" align="right" width="400px" srcset=""/>
     <img alt="Screenshot of my desktop" align="right" width="400px" src="assets/dotfiles.png"/>
</picture>
</a>

My fully automated dev environment is built to ✨spark joy✨. Aesthetics **and** performance are prioritized. 

#### Quick details about my setup:

#### macOS
 * **Operating System**: [macOS Monterey](https://www.apple.com/by/macos/monterey/)
 * **Automation Tool**: [hammerspoon](https://github.com/Hammerspoon/hammerspoon) ([config](/tools/misc/hammerspoon))
 * **Window Manager**: [yabai](https://github.com/koekeishiya/yabai) ([config](/wm/yabai))
 * **Terminal Emulator**: [kitty](https://sw.kovidgoyal.net/kitty/) ([config](/terminals/kitty))
 * **Shell**: [fish](https://fishshell.com/) ([config](/shells/fish))
 * **Editor**: [neovim](http://neovim.io/) ([config](/editors/nvim))
 * **Browser**: [Brave](https://brave.com/)
 * **App Launcher**: [Raycast](https://raycast.com) ([config](/launchers/raycast))
 * **Keyboard Customizer**: [Karabiner](https://karabiner-elements.pqrs.org/) ([config](/tools/keys/karabiner))
 * **Menubar**: [Sketchybar](https://felixkratz.github.io/SketchyBar/config/bar) ([config](/statusbars/sketchybar))

<h1>
  <a href="#---------1">
    <img alt="" align="right" src="https://img.shields.io/github/commit-activity/m/meaganewaller/dotfiles/ng?style=flat-square&label=&color=000000&logo=gitbook&logoColor=white&labelColor=000000"/>
  </a>
</h1>

<br>

<p align="right">
[<a href="https://gitlab.com/meagan/dotfiles">mirror</a>]
</p>

## 🌱 <samp>SETUP</samp>

I use <a href="https://github.com/anishathalye/dotbot">dotbot</a> to bootstrap my dotfiles. This allows me to keep a versioned directory of all my config files that are symlinked into place via a command. This lets me share my files with you.

### 🧪🔬<samp> EXPERIMENTAL & NOT GUARANTEED</samp> 💁‍♀️

I update this constantly with poor git habits. There are no guarantees of stability, working on any machine but my own (and sometimes, tbh not even my own), or a "productive" "enjoyable" "experience".

> It's probably best that you dig into the configs yourself. It's _not_ the best habit to install mine--A Stranger's--shell scripts. But also, you do you. 


### <samp>INSTALLING</samp>

### :blossom: ‎ <samp>INSTALLATION (<a href="./REPOLOGY.md">DEPENDENCIES</a>)</samp>

_Get up and running right now:_

```sh
💲 cd ~
💲 git clone git@github.com:meaganewaller/.dotfiles.git
💲 cd .dotfiles
💲 make install
```

_Update an existing installation:_

```sh
💲 make -C ~/.dotfiles up
```

<details>
<summary><samp><b>macOS distros</b></samp></summary>


```sh
💲 cd ~/.dotfiles && make macos
💲 make -C ~/.dotfiles macos
```

```sh
💲 cd ~/.dotfiles && make help
💲 make -C ~/.dotfiles help
```
</details>

<details>
<summary><samp><b>arch linux distros</b></samp></summary>


```sh
💲 cd ~/.dotfiles && make arch
💲 make -C ~/.dotfiles arch
```

```sh
💲 cd ~/.dotfiles && make help
💲 make -C ~/.dotfiles help
```
</details>

## <samp>✨TOOLS & RESOURCES</samp>
These are the one true way[^1].

- [kitty](https://github.com/kovidgoyal/kitty)
- [neovim](https://neovim.io/)
- [fish](https://fishshell.com/)
- [asdf](https://asdf-vm.com/)
- [sketchybar](https://github.com/FelixKratz/SketchyBar)
- [skhd](https://github.com/koekeishiya/skhd)
- [homebrew](https://brew.sh/)
- [fira code nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)
- [ibm plex](https://www.ibm.com/plex/)
- [bigblue terminal](https://int10h.org/blog/2015/12/bigblue-terminal-oldschool-fixed-width-font/)
- [hammerspoon](https://www.hammerspoon.org/)
- [karabiner elements](https://github.com/tekezo/Karabiner-Elements)


[^1]: Subject to change at any time a shiny new tool catches my eye.

## 🌻 <samp> KEY BINDINGS </samp>
I use karabiner to bind certain keys to seldom-used function keys of F17, F18, F19. Using hammerspoon I set my hyper key to F18, this allows me to still have access to all modifiers (ctrl, alt, cmd, shift)[^2].

| Key | Action |
|:----|:-------|
| <kbd>F19</kbd> + <kbd>⯇</kbd> | Move window focus to left-side |
| <kbd>F19</kbd> + <kbd>⯈</kbd>                                                                                                                            | Move window focus to right-side                   |
| <kbd>F19</kbd> + <kbd>⯅</kbd>                                                                                                                            | Move window focus to up-side                      |
| <kbd>F19</kbd> + <kbd>⯆</kbd>                                                                                                                            | Move window focus to down-side                    |



[^2]: Evan Travers' [blog post about a Better Hyper Key](https://evantravers.com/articles/2020/06/08/hammerspoon-a-better-better-hyper-key/) is the inspiration behind this.
## Credits

</div>
