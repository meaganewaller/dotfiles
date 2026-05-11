# dotfiles

> there's no place like `~`

## installation

### quick start

```bash
git clone https://github.com/meaganewaller/dotfiles && cd dotfiles && ./install
```

### advanced usage

the installer supports some options and can pass args directly to `chezmoi init`:

```bash
# force reinstall tools (if already installed)
REINSTALL_TOOLS=true ./install

# Pass args to chezmoi init
./install -- --force         # Force chezmoi to overwrite existing files
./install -- --one-shot      # Use chezmoi's one-shot mode

# Conbine options
REINSTALL_TOOLS=true ./install -- --force
```

### env vars

- `REINSTALL_TOOLS=true` - Force reinstallation of tools even if already present
- `BIN_DIR=/custom/path` - Install binaries to a custom directory (default: `~/.local/bin`)
- `DEBUG=1` - Enable debug output during installation
- `VERIFY_SIGNATURES=false` - Disable signature verification (not recommended)

For a complete list of options, run `./install --help`.