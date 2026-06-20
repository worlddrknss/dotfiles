# Dotfiles

> Professional development environment configuration files for macOS systems

[![Maintenance](https://img.shields.io/badge/maintained-yes-green.svg)](https://github.com/worlddrknss/dotfiles)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Repository Structure](#repository-structure)
- [Usage](#usage)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Support](#support)

## Overview

This repository contains a curated collection of configuration files (dotfiles) designed to provide a consistent, efficient, and professional development environment on macOS. These configurations are optimized for productivity and follow industry best practices.

### Purpose

- **Consistency**: Maintain uniform development environments across your macOS machines
- **Efficiency**: Reduce setup time and configuration overhead
- **Productivity**: Pre-configured tools and settings for optimal workflow
- **Version Control**: Track and manage configuration changes over time

## Features

- 🔧 **Shell Configuration**: Optimized shell settings (Zsh)
- 📝 **Editor Configuration**: Vim/Neovim or other editor settings
- 🎨 **Terminal Customization**: Enhanced terminal experience
- 🔐 **Security**: Secure credential management practices
- 🚀 **Performance**: Optimized settings for system performance
- 📦 **Package Management**: Integration with common package managers
- 🔄 **Synchronization**: Easy deployment across multiple macOS machines

## Prerequisites

Before installing these dotfiles, ensure you have the following:

- **Operating System**: macOS (10.15+)
- **Shell**: Zsh
- **Git**: Version 2.20.0 or higher
- **Administrative Access**: Required for some installation steps

### Required Tools

- **Homebrew**: https://brew.sh/ (macOS)
- **Zsh**: recommended shell
- **Git**: Version 2.20.0 or higher
- **Starship**: Minimal, fast prompt (https://starship.rs/)
- **Mise**: Runtime manager used by the shell configuration

### Homebrew packages

This setup depends on the following Homebrew packages (install on macOS with Homebrew):

- bat
- eza
- figlet
- fzf
- neovim
- ripgrep
- stow
- zoxide
- zsh-autocomplete
- zsh-autosuggestions
- zsh-syntax-highlighting

Install them with:

```bash
# Install Homebrew first (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required packages
brew install bat eza figlet fzf neovim ripgrep stow zoxide starship mise

# Some zsh plugins may be installed via brew or cloned into your zsh plugins directory:
# e.g. brew install zsh-autosuggestions zsh-syntax-highlighting
```

### Optional Extras

- [Oh My Zsh](https://ohmyz.sh/) or similar shell framework

## Installation

### Manual Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/worlddrknss/dotfiles.git ~/.dotfiles
   ```

2. **Review configuration files**:

   ```bash
   cd ~/.dotfiles
   ls -la
   ```

3. **Create symbolic links** (or copy files as needed):

   ```bash
   # Example for .zshrc
   ln -s ~/.dotfiles/.zshrc ~/.zshrc
   ```

4. **Reload your shell**:

   ```bash
   source ~/.zshrc
   ```

### Installation Options

- **Full Installation**: Link all relevant configuration files
- **Selective Installation**: Link only the components you want

## Configuration

### Customization

All configuration files are designed to be easily customizable. Key configuration areas include:

- **Shell Aliases**: Located in `.zshrc`
- **Editor Settings**: Vim/Neovim configuration files
- **Tool Configuration**: Settings under `.config/` (Neovim, WezTerm, Starship)
- **Environment Variables**: `.env` or shell-specific environment files

### Environment-Specific Settings

Configuration supports local machine-specific overrides:

```bash
# Local overrides (not tracked in git)
~/.zshrc.local
```

## Repository Structure

```text
dotfiles/
├── README.md              # This file
├── .zshrc                 # Zsh configuration
├── .config/               # Tool and application configurations
└── .git/                  # Git repository metadata
```

## Usage

### Daily Operations

After installation, the dotfiles work automatically. No additional steps are required for normal usage.

### Updating Configuration

```bash
# Navigate to dotfiles directory
cd ~/.dotfiles

# Pull latest changes
git pull origin main

# Reload shell config after updates
source ~/.zshrc
```

### Adding New Configurations

1. Add your configuration file to the repository
2. Update documentation if needed
3. Commit and push changes:

   ```bash
   git add .
   git commit -m "Add new configuration"
   git push origin main
   ```

## Maintenance

### Regular Tasks

- **Update Dependencies**: Keep system packages and tools up to date
- **Review Configuration**: Periodically review and optimize settings
- **Backup**: Ensure dotfiles are backed up (version control provides this)
- **Testing**: Test configuration changes in a fresh shell before committing

### Version Management

This repository uses semantic versioning for major releases:

- **Major**: Breaking changes or significant restructuring
- **Minor**: New features or configurations
- **Patch**: Bug fixes and minor improvements

## Troubleshooting

### Common Issues

#### Configuration Not Applied

**Problem**: Changes to dotfiles don't take effect.

**Solution**:

```bash
# Reload shell configuration
source ~/.zshrc
```

#### Symbolic Link Conflicts

**Problem**: Existing configuration files conflict with dotfiles.

**Solution**:

```bash
# Backup existing files
mv ~/.zshrc ~/.zshrc.backup

# Create new symbolic link
ln -s ~/.dotfiles/.zshrc ~/.zshrc
```

### Getting Help

If you encounter issues not covered here:

1. Check the [Issues](https://github.com/worlddrknss/dotfiles/issues) page
2. Review recent commits for changes
3. Review README updates in recent commits

## Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**: Follow existing code style and conventions
4. **Test thoroughly**: Ensure changes work on macOS
5. **Commit changes**: Use clear, descriptive commit messages
6. **Push to branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**: Provide detailed description of changes

### Contribution Guidelines

- Follow existing code style and formatting
- Add comments for complex configurations
- Update documentation for new features
- Test on current and recent macOS versions when possible
- Keep commits focused and atomic

## Support

### Resources

- **Documentation**: See this README for setup and usage notes
- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/worlddrknss/dotfiles/issues)
- **Discussions**: Join discussions in [GitHub Discussions](https://github.com/worlddrknss/dotfiles/discussions)

### Contact

For questions or support:

- **Email**: See GitHub profile for contact information
- **GitHub**: [@worlddrknss](https://github.com/worlddrknss)

---

**Last Updated**: 2026-06-19
**Maintainer**: worlddrknss

