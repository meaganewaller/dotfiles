# 🧙‍♂️ asdf version manager

asdf is a tool version manager that simplifies development workflows by consolidating tool version definitions into one file (`.tool-versions`) that can be shared with your team via Git repositories.
It replaces the need for multiple CLI version managers, each with distinct configurations and implementations, providing a single interface for managing various tools and runtimes through plugins.

here's how it works:

- after setting up asdf core with your Shell configuration, you install plugins to manage specific tools.
- when a tool is installed, asdf creates shims for its executables. running a tool's executable invokes the shim, allowing asdf to
  execute the specified version from the `.tool-versions` file.

## why asdf?

- ensures consistent tool versions across teams.
- supports various tools through plugins.
- simplifies workflows with a unified shell script.

> **note:** asdf is a tool version manager, not a system package manager, and it's essential to choose it for tools wisely.
