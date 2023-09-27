# 🚀 Getting Started

dotfiles installation involves a few steps:

1. installing minimal dependencies
2. cloning this repo
3. backing up your existing dotfiles (if any)
4. running the install script
  4.5 waiting quite a while for the install script to finish
5. restarting your shell--better yet, restarting your computer
6. enjoying your new productive machine

## 1. installing minimal dependencies

at the very least, you'll need `git`, `ruby`, and the `rake` gem installed.

| OS    | Package Manager | Command              |
| -     | -               | -                    |
| linux | Aptitude        | `apt install git`    |
| linux | DNF             | `dnf install git`    |
| linux | Pacman          | `pacman -S curl git` |
| macOS | Homebrew        | `brew install git`   |
| macOS | Spack           | `spack install git`  |

::: tip Note

`sudo` may be required for some of these commands depending on your system config.

:::

## 2. cloning this repo

```shell
git clone https://github.com/meaganewaller/dotfiles.git ~/.dotfiles

```

## 3. backing up your existing dotfiles (if any)

```shell
cd ~/.dotfiles
rake backup
```

## 4. running the install script

```shell
cd ~/.dotfiles
rake install
```

## 4.5 waiting quite a while for the install script to finish

this step takes a while. go get a coffee or something.

## 5. restarting your shell--better yet, restarting your computer

to make sure all the new settings take effect.

## 6. enjoying your new productive machine

check out some of the guides below to learn how to use your new dotfiles.
