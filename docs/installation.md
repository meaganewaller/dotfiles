# Dotfiles Installation in 6 Steps

1. **Install Minimal Dependencies:** At a minimum, ensure you have `git`, `ruby`, and the `rake` gem installed.
2. **Clone This Repository:**
  Use the following command to clone the repository to `~/.dotfiles`:
  ```shell
  git clone https://github.com/meaganewaller/dotfiles.git ~/.dotfiles
  ```
3. **Back Up Existing Dotfiles (If Any):**
Navigate to ~/.dotfiles and run:

  ```shell
  rake backup
  ```
4. **Run the Install Script:**
Go to `~/.dotfiles` and execute:
  ```shell
  rake install
  ```
Note: This step takes some time; use this time to practice juggling or
something.
5. **Restart Your Shell (or Your Machine):**
To ensure all new settings take effect.
6. **Enjoy Your Productive Machine:**
Explore the guides to learn how to use your new dotfiles.

