# installation

my dotfiles installation involves a few steps:

  1. installing minimal dependencies
  2. cloning this repo
  3. backing up your existing dotfiles (if any)
  4. running the install script (and waiting quite a while for it to run)
  5. restarting your shell--better yet, restarting your machine
  6. enjoying your new cute and productive machine


## 1. installing minimal dependencies

at the very least, you'll need `git`, `ruby`, and the `rake` gem installed.

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

this step takes a while. use this time to practice juggling or something.

## 5. restarting your shell--better yet, restarting your machine

to make sure all the new settings take effect.

## 6. enjoying your new productive machine

check out the guides to learn how to use your new dotfiles.


