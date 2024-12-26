#!/bin/zsh

# install homebrew if not already installed.
echo -e "\Checking for Homebrew..."
if ! type brew &>/dev/null; then
    echo "Installing Homebrew..."
    # nosemgrep
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
    echo -e "${GREEN_B}Homebrew is now installed!${RESET}"
else
    echo -e "${GREEN_B}Homebrew is already installed!${RESET}"
fi
