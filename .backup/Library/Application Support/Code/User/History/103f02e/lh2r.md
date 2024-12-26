<div align="justify">
    <div align="center">
        <pre align="center">
        ╔════════════════ °❀•°✮°•❀° ═════════════════╗<br>
        ✧･ﾟ:*<a href="#-setup">Setup</a> ✧ <a href="#--key-bindings">Keybinds</a> ✧ <a href="https://github.com/meaganewaller/dotfiles/wiki/Gallery">Gallery</a> ✧ <a href="#-guides">Guides</a>*:･ﾟ✧ <br>
        ╚════════════════ °❀•°✮°•❀° ═════════════════╝
        </pre>
    </div>
</div>

<pre align="center">

┌┬┐┬ ┬┌─┐┬─┐┌─┐┌─┐  ┌┐┌┌─┐  ┌─┐┬  ┌─┐┌─┐┌─┐  ┬  ┬┬┌─┌─┐
│ ├─┤├┤ ├┬┘├┤ └─┐  ││││ │  ├─┘│  ├─┤│  ├┤   │  │├┴┐├┤
 ┴ ┴ ┴└─┘┴└─└─┘└─┘  ┘└┘└─┘  ┴  ┴─┘┴ ┴└─┘└─┘  ┴─┘┴┴ ┴└─┘
° ˛ ° ˚*_Π_____*☽*˚ ˛
✩ ˚˛˚*   /______/__＼。✩˚ ˚˛
˚ ˛˚˛˚｜ 田田｜門｜ ˚ ˚

</pre>

# [![repo visits](https://badges.pufler.dev/visits/meaganewaller/dotz?style=flat-square&label=&color=000000&logo=github&logoColor=white&labelColor=000000)](#)

</div>

# 🌷 <sup><sub><samp> welcome to my dotfiles! </samp></sub></sup>

My fully automated dev environment is built to ✨spark joy✨. Aesthetics **and** performance are prioritized.

## Quick details about my setup

### macOS

- **Operating System**: [macOS Sequoia 15.0.1 (24A348)](https://apple.com/macos/macos-sequoia/)
- **Terminal Emulator**: [wezterm](https://wezfurlong.org/wezterm/index.html)
- **Shell**: [fish](https://fishshell.com/)
- **Editor**: [neovim](https://neovim.io/)
- **App Launcher**: [raycast](https://raycast.com)

<h1>
  <a href="#---------1">
    <img alt="" align="right" src="https://img.shields.io/github/commit-activity/m/meaganewaller/dotz/main?style=flat-square&label=&color=000000&logo=gitbook&logoColor=white&labelColor=000000"/>
  </a>
</h1>

<br />

## 🌱 <samp>SETUP</samp>

I use [dotbot](https://github.com/anishathalye/dotbot) to bootstrap my dotfiles. This allows me to keep a versioned
directory of all my config files that are symlinked into place via a command. This lets me share my dotfiles with _you_.

### 🧪🔬<samp> EXPERIMENTAL & NOT GUARANTEED</samp> 💁‍♀️

I update this constantly with poor git habits. There are no guarantees of stability, working on any machine but my own (and sometimes, tbh not even my own), or a "productive" "enjoyable" "experience".

> It's highly recommended that you dig into the configs yourself. It's _not_ the best habit to install mine--A Stranger's--shell scripts. But also, you do you.

### <samp>INSTALLING</samp>
### :blossom: ‎ <samp>INSTALLATION ([DEPENDENCIES](./REPOLOGY.md))</samp>

**1. Clone the dotfiles repository:**

```sh
💲 cd ~
💲 git clone git@github.com:meaganewaller/dotz.git ~/.dotfiles
```

The rabbit hole awaits.

**2. Navigate to the Dotfiles Directory:**

```sh
💲 cd ~/.dotfiles
```

Welcome to the rabbit hole. You can't go back now. This is where the magic happens. And the magic is a Makefile.

**3. Backup your existing config:**

```sh
💲 make backup
💲 make # alias for make backup
```
Ok, so maybe you can go back. But only if you've backed up your existing configs. This command will copy any existing dotfiles into a `~/.dotfiles-backup` directory. You can use this to restore your original configs if you decide to go back to the way things were.

**4. Run the installation script:**
```sh
💲 make install
```

This is where the real fun begins. Buckle up as the configurations are symlinked into place, packages are installed, and defaults are set. This may take a while.

**5. Updating an existing installation:**

```sh
💲 make update
```
Already in the rabbit hole? Keep your configs up to date with the latest changes by running the `up` command.

<hr style="border:1px dashed pink" />

now you're all set to explore the depth of my (and now _yours_) dotfiles. enjoy the ride. with great customization comes
great responsibility, or whatever uncle ben said.

</div>