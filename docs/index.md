---
title: 'my dotfiles'
home: true
heroImage: /hero.jpg
heroAlt: 'meaganewaller/dotfiles'
heroText: 'my dotfiles'
tagline: 'aesthetics & productivity'
actionText: get going
actionLink: '/#installation'
footer: 'MIT © Meagan Waller'
---

<pre style="font-family: 'IBM Plex Mono', monospace; font-size: 1.5rem; line-height: 1.5;" align="center">
  ┌┬┐┬ ┬┌─┐┬─┐┌─┐┌─┐  ┌┐┌┌─┐  ┌─┐┬  ┌─┐┌─┐┌─┐  ┬  ┬┬┌─┌─┐
   │ ├─┤├┤ ├┬┘├┤ └─┐  ││││ │  ├─┘│  ├─┤│  ├┤   │  │├┴┐├┤
   ┴ ┴ ┴└─┘┴└─└─┘└─┘  ┘└┘└─┘  ┴  ┴─┘┴ ┴└─┘└─┘  ┴─┘┴┴ ┴└─┘
  ° ˛ ° ˚*_Π_____*☽*˚ ˛
  ✩ ˚˛˚*   /______/__＼。✩˚ ˚˛
  ˚ ˛˚˛˚｜ 田田｜門｜ ˚ ˚
</pre>

## 🌷 welcome to my dotfiles

my fully automated dev environment is built to ✨spark joy✨. aesthetics **and** performance are prioritized.

i've spent countless hours tweaking and tuning my setup to perfection. *this is a constant work in progress*.

::: info
as a disclaimer, these dotfiles are tailored to my specific needs and preferences. i'm sharing them in the hopes that they'll inspire you to create your own dotfiles and customize them to suit your needs. i'm always open to feedback and suggestions, so feel free to reach out if you have any ideas for improvement.
:::

## ✨ the all-star cast

allow me to introduce you to my trusted accomplices. keep in mind that my loyalty to any given tool is fickle and subject to change at any moment a shiny new one catches my eye. but for now, here's the current ensemble:

### 🧙‍♂️ asdf version manager

- **website:** [asdf](https://asdf-vm.com/)
- **description:** asdf is the wizard behind the curtain, managing my development environment with ease. It's like having a magic wand for installing and switching between programming languages.

### 🖼️ bigblue terminal font

- **website:** [bigblue terminal](https://int10h.org/blog/2015/12/bigblue-terminal-oldschool-fixed-width-font/)
- **description:** bigblue terminal font takes me back to the good old days of computing. It's retro, it's fixed-width, and it's just plain cool.

### 🪄 fira code nerd font

- **github:** [fira code nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/firacode)
- **description:** fira code nerd font is the font of choice for my code. It's like the perfect pair of jeans—it just fits right and makes everything look good.

### 🐟 fish shell

- **website:** [fish](https://fishshell.com/)
- **description:** the Fish shell is my trusty sidekick in the command-line world. It's user-friendly, intuitive, and always ready to lend a helping fin.

### 🤖 hammerspoon automation tool

- **website:** [hammerspoon](https://www.hammerspoon.org/)
- **description:** hammerspoon is my digital butler, automating tasks and making my life easier. It's like having a personal assistant in code form.

### 🍺 homebrew package manager

- **website:** [homebrew](https://brew.sh/)
- **description:** homebrew is the bartender of my system, serving up all the software I need with a simple command. It keeps my system well-hydrated with the latest apps.

### 📝 ibm plex typeface

- **website:** [ibm plex](https://www.ibm.com/plex/)
- **description:** ibm plex is my typographic muse. It's clean, modern, and adds a touch of class to my monitor. I pretty much only use it for italics.

### ⌨️  karabiner elements keyboard customizer

- **github:** [karabiner elements](https://github.com/tekezo/Karabiner-Elements)
- **description:** karabiner elements is my key manipulator, shaping keyboard behaviors to adapt effortlessly to different layouts and key combinations. It's a versatile tool for customizing key functions to suit my needs.

### 🐱 kitty terminal emulator

- **github**: [kitty](https://github.com/kovidgoyal/kitty)
- **description**: the kitty terminal emulator is the cat's meow when it comes to terminal experiences. It's fast, it's customizable, and it's got a cute name with a cute icon. What more could you want? It's purr-fectly suited for my daily coding antics.

### ✒️  neovim code editor

- **website:** [neovim](https://neovim.io/)
- **description:** neovim is my code sanctuary. It's like a Swiss army knife for text editing but with more shortcuts and fewer corkscrews. Vim enthusiasts, rejoice!

### 🌈 sketchybar menubar

- **github:** [sketchybar](https://github.com/FelixKratz/SketchyBar)
- **description:** like a chameleon for your desktop, sketchybar changes hues to match my mood and serves as a trusty heads-up display for key information.

### ⚙️  skhd shortcut daemon

- **github:** [skhd](https://github.com/koekeishiya/skhd)
- **description:** a silent conductor orchestrating my custom keyboard shortcuts, working tirelessly behind the scenes.

### 🪟 yabai window manager

- **github:** [yabai](https://github.com/koekeishiya/yabai)
- **description:** yabai is the artist of my screen, painting windows with the brush of my keyboard. it's a tiling window manager that keeps my desktop tidy and my workflow efficient.

now that you've met the crew, feel free to explore their individual quirks and see how they contribute to the symphony of my digital life.

<br />

<style>
details>summary {
  font-size: 1.3em;
  font-weight: 700;
  padding: 5px 10px;
  margin: 25px 0 6px 0;
  border-radius: 6px;
  border: 1px solid var(--c-divider-dark);
  border-bottom: 2px solid var(--c-divider-dark);
  cursor: pointer;
}
details:not([open])>summary {
  background-color:var(--c-divider-light);
}
@media (prefers-color-scheme: dark) {
  :root {
    --c-bg: #112233 !important;
    --c-text: #f0f0f0 !important;
    --c-text-light-3: #2c3e50 !important;
    --c-text-light-2: #476582 !important;
    --c-text-light-1: #90a4b7 !important;
    --c-white: #112233 !important;
    --c-white-dark: #000000 !important;
    --c-black: #f0f0f0 !important;
    --c-divider-light: rgba(230, 230, 230, .12) !important;
    --c-divider-dark: rgba(200, 200, 200, .48) !important;
  }
}
</style>
