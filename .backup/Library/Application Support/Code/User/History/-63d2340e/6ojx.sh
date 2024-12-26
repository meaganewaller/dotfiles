#!/bin/zsh

# install homebrew if not already installed.
echo -e "\nChecking for Homebrew..."
if ! type brew &>/dev/null; then
    echo "Installing Homebrew..."
    # nosemgrep
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
    echo -e "${GREEN_B}Homebrew is now installed!${RESET}"
else
    echo -e "${GREEN_B}Homebrew is already installed!${RESET}"
fi

# configure homebrew
brew developer off
brew analytics off

# install apps and packages from brewfile via homebrew bundle
echo
echo "Installing macos apps and packages from Brewfile..."
brew tap homebrew/bundle
if ! brew bundle check; then
    brew bundle install --no-lock --cleanup
fi

# perform upgrades and cleanup
if [[ ! -z "${CI}" ]]; then
brew upgrade
fi
brew cleanup
brew info