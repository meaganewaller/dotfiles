#!/bin/bash

install_terminal_theme() {
	local theme_url="https://raw.githubusercontent.com/pineapplegiant/spaceduck-terminal/refs/heads/main/spaceduck.terminal"
	local expected_sha256="d5738f90802747aeb7eb2ae1ca948a41a44d41fbf37e4bf28c81dbb45d9484fd"
	local theme_file="/tmp/spaceduck.terminal"
	local theme_name="spaceduck"

	echo "Downloading $theme_name terminal theme..."

	# Download the theme
	if ! curl -fsSL "$theme_url" -o "$theme_file"; then
		echo "Failed to download $theme_name terminal theme"
		return 1
	fi

	 echo "Validating SHA256 checksum..."

    # Calculate and verify SHA256
    local actual_sha256
    if command -v shasum >/dev/null 2>&1; then
        actual_sha256=$(shasum -a 256 "$theme_file" | cut -d' ' -f1)
    elif command -v sha256sum >/dev/null 2>&1; then
        actual_sha256=$(sha256sum "$theme_file" | cut -d' ' -f1)
    else
        echo "Error: Neither shasum nor sha256sum found"
        rm -f "$theme_file"
        return 1
    fi

    if [[ "$actual_sha256" != "$expected_sha256" ]]; then
        echo "Error: SHA256 mismatch!"
        echo "Expected: $expected_sha256"
        echo "Actual:   $actual_sha256"
        rm -f "$theme_file"
        return 1
    fi

    echo "✓ SHA256 verified successfully"
	echo "Installing $theme_name terminal theme..."

	# Install the theme
	open "$theme_file"
	sleep 2

	# Set as default
	echo "Setting $theme_name as default terminal theme..."
	defaults write com.apple.terminal "Default Window Settings" -string "$theme_name"
	defaults write com.apple.terminal "Startup Window Settings" -string "$theme_name"

	rm -f "$theme_file"

    echo "✓ $theme_name theme installed successfully!"
    echo "You may need to restart Terminal to see all changes."
}

# Only run on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    install_terminal_theme
fi