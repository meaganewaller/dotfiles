# skhd Configuration

This directory contains the configuration files for [skhd](https://github.com/koekeishiya/skhd), a hotkey daemon for macOS. It's designed to work in conjunction with the [yabai](https://github.com/koekeishiya/yabai) window manager.

## Installation

### Dependencies

Before using this configuration, make sure you have the following dependencies
installed:

- [skhd](https://github.com/koekeishiya/skhd): The hotkey daemon that handles
keybindings.
- [yabai](https://github.com/koekeishiya/yabai): A tiling window manager for
macOS.
- [jq](https://jqlang.github.io/jq/): A lightweight and flexible command-line
JSON processor. It's used to parse information about windows.

### Link skhd Config

Use the following command to link the skhd configuration file:

```bash
./install-standalone skhd
```

Make sure `skhd` is set up to run at startup. This can be done by adding the
following line to your shell profile (e.g., `.bashrc`):

```bash
skhd -d
```

Reload your shell configuration or restart your terminal.

## Usage

This configuration defines various keybindings and modes for interacting with
`yabai` and launching applications. Below is a brief overview of the
keybindings and their functionality:

- **Modes**: This configuration defines different modes for various
actions, such as resizing, changing layouts, moving windows, launching
applications, and system commands.

- **Navigation**: Use key combinations to navigate between windows, spaces, and displays.

- **Window Management**: Manage windows, including moving, resizing, and toggling various window states (e.g., floating).

- **Gaps and Layout**: Adjust gaps and layouts for your workspace.

- **Application Launching**: Quickly launch or focus on specific applications, such as Obsidian and Kitty.

- **System Commands**: Reload the skhd configuration or switch back to the default mode.

## Customizing Keybindings

Feel free to customize the keybindings to suit your preferences. The configuration is well-documented, making it easy to understand and modify.

## About the Included Scripts

The repository also includes scripts for launching and focusing on specific applications. These scripts are used in the skhdrc configuration to interact with applications like Obsidian and Kitty. You can use or modify these scripts to suit your needs.

- `apps/obsidian`: Script for launching or focusing on the Obsidian note-taking app.

- `apps/kitty`: Script for launching or focusing on the Kitty terminal emulator.

## Acknowledgements

- This configuration is designed to work with the `yabai` window manager.
- It uses `jq` to parse information about windows, so make sure you have `jq`
installed.

## License

This configuration is provided under the [MIT License](https://chat.openai.com/c/LICENSE). You are free to use, modify, and distribute it as per the terms of the license.

Happy keybinding!





