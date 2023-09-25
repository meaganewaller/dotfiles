# 🪟 Managing Windows with Yabai

## 🌌 Introduction

Welcome to the realm of window management mastery with Yabai. This guide, curated by Meagan Waller, is your key to understanding and optimizing Yabai's configuration. Whether you're a newcomer or a seasoned Yabai wizard, this guide will enlighten you on harnessing the power of macOS tiling window management.

## 🪄 Configuration Script Overview

The Yabai configuration script is the heart of your window management setup. It's composed of various sections, each serving a unique purpose.

### 🌊 Dock Restart Handling

- **Command**: `yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"`
- **Description**: This line ensures Yabai reloads when the macOS Dock restarts, ensuring seamless integration.

### ⚡ Signal Hooks

Signal hooks dictate Yabai's response to events:

- **Window Destruction**: Yabai focuses on the next window in the current space after window destruction.
- **Minimized Window**: If a minimized floating window exists, Yabai focuses on the next window in the current space.
- **Window Focus**: Updates the "sketchybar" when a window is focused.
- **Window Creation/Destruction**: Keeps the "sketchybar" in sync with window creation and destruction.

### 🌟 Bar Configuration

- **Variable**: `BAR_HEIGHT`
- **Command**: `create_spaces 9`
- **Description**: Customize your "sketchybar" height and create the desired number of spaces for productivity.

### 🚀 General Configuration

- **Description**: Fine-tune general settings, including split type, split ratio, and auto-balancing, to suit your workflow.

### 🪟 Window Configuration

- **Description**: Define window management settings, control opacity, shadows, and borders for the perfect window experience.

### 🏠 Layout Configuration

- **Description**: Craft your ideal layout style, adjust padding, and set window gaps to perfection.

### 🖱️ Mouse Configuration

- **Description**: Configure mouse interactions with modifiers and actions to streamline your workflow.

### 🌐 Space Labels

- **Description**: Give your spaces meaningful labels like "main," "code," or "chat" for easy navigation.

### 📜 Rules

- **Description**: Define rules for managing specific apps, unmanage apps, make apps sticky, and position apps in specific spaces.

### 🎯 Centered Windows

- **Description**: Center windows for specific apps using grid positioning, enhancing your visual experience.

### 🪐 Specific Space Configuration

- **Description**: Customize layouts and window opacity settings for specific spaces, optimizing your workflow.

### 🚫 Excluded Apps

- **Description**: Specify apps to exclude from Yabai's window management, ensuring uninterrupted usage.

## 💡 Tips for Using This Configuration

- Customize the configuration to align with your preferences and workflow.
- Stay up-to-date with changes and enhancements by referring to the provided GitHub links.
