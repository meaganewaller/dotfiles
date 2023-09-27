---
outline: deep
---

# FAQ

## What are dotfiles?

Dotfiles are configuration files that are used to customize your system. They're
called dotfiles because they typically are prefixed with a `.`. For example, the
configuration file for the Bash shell is `.bashrc`.

## Why should I use dotfiles?

Dotfiles are a great way to customize your system. They allow you to configure
your system to your liking, and they can be used to automate tasks. For example,
you can use dotfiles to install software, configure your system, and even
automate tasks.

## How do I use dotfiles?

Dotfiles are typically stored in a directory called `~/.dotfiles`. This
directory is typically located in your home directory. You can use the `git`
command to clone the dotfiles repository into your home directory.

```bash
git clone https://github.com/meaganewaller/dotfiles.git ~/.dotfiles

```

## Who uses dotfiles?

Dotfiles are used by many people, including developers, system administrators,
and even some non-technical people. They're a great way to customize your
system, and they can be used to automate tasks.

## Can I uninstall the dotfiles?

Yes, you can uninstall these dotfiles. You can use the `rake install` command to remove the
symlinks that were created when you installed the dotfiles.

```bash
cd ~/.dotfiles
rake uninstall

```

Before you install the dotfiles, you should make sure that you have a backup of
your existing dotfiles. You can use the `rake backup` command to create a
backup of your existing dotfiles.

```bash
cd ~/.dotfiles
rake backup

```

## How do I update the dotfiles?

The dotfiles are updated using the `rake update` command. This
command will pull the latest changes from the dotfiles repository and
update packages, if necessary.

```bash
cd ~/.dotfiles
rake update

```
