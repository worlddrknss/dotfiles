# Dotfiles

> Professional development environment configuration files for macOS/Linux systems

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
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
- [License](#license)
- [Support](#support)

## Overview

This repository contains a curated collection of configuration files (dotfiles) designed to provide a consistent, efficient, and professional development environment across multiple systems. These configurations are optimized for productivity and follow industry best practices.

### Purpose

- **Consistency**: Maintain uniform development environments across different machines
- **Efficiency**: Reduce setup time and configuration overhead
- **Productivity**: Pre-configured tools and settings for optimal workflow
- **Version Control**: Track and manage configuration changes over time

## Features

- 🔧 **Shell Configuration**: Optimized shell settings (Zsh/Bash)
- 📝 **Editor Configuration**: Vim/Neovim or other editor settings
- 🎨 **Terminal Customization**: Enhanced terminal experience
- 🔐 **Security**: Secure credential management practices
- 🚀 **Performance**: Optimized settings for system performance
- 📦 **Package Management**: Integration with common package managers
- 🔄 **Synchronization**: Easy deployment across multiple systems

## Prerequisites

Before installing these dotfiles, ensure you have the following:

- **Operating System**: macOS (10.15+) or Linux (Ubuntu 20.04+, Debian 11+, or equivalent)
- **Shell**: Zsh (recommended) or Bash
- **Git**: Version 2.20.0 or higher
- **Administrative Access**: Required for some installation steps

### Optional Dependencies

- [Homebrew](https://brew.sh/) (macOS) or [APT](https://wiki.debian.org/Apt) (Linux)
- [Oh My Zsh](https://ohmyz.sh/) or similar shell framework
- [Git](https://git-scm.com/) for version control

## Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/worlddrknss/dotfiles.git ~/.dotfiles

# Navigate to the repository
cd ~/.dotfiles

# Run the installation script (if available)
./install.sh
```

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

- **Full Installation**: Installs all configuration files
- **Selective Installation**: Choose specific components to install
- **Dry Run**: Preview changes without applying them

## Configuration

### Customization

All configuration files are designed to be easily customizable. Key configuration areas include:

- **Shell Aliases**: Located in `.zshrc` or `.bashrc`
- **Editor Settings**: Vim/Neovim configuration files
- **Git Configuration**: `.gitconfig` for version control settings
- **Environment Variables**: `.env` or shell-specific environment files

### Environment-Specific Settings

Configuration files support environment-specific overrides:

```bash
# Local overrides (not tracked in git)
~/.dotfiles/local/.zshrc.local
~/.dotfiles/local/.gitconfig.local
```

## Repository Structure

```text
dotfiles/
├── README.md              # This file
├── LICENSE                # License information
├── install.sh             # Installation script
├── .zshrc                 # Zsh configuration
├── .bashrc                # Bash configuration
├── .gitconfig             # Git configuration
├── .vimrc                 # Vim configuration
├── bin/                   # Custom scripts and utilities
├── config/                # Additional configuration files
└── docs/                  # Additional documentation
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

# Apply updates (if installation script handles this)
./install.sh --update
```

### Adding New Configurations

1. Add your configuration file to the repository
2. Update the installation script if needed
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
- **Testing**: Test configurations on new systems before deployment

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
source ~/.zshrc  # or source ~/.bashrc
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

#### Permission Issues

**Problem**: Installation script fails due to permissions.

**Solution**:

```bash
# Make script executable
chmod +x install.sh

# Run with appropriate permissions
./install.sh
```

### Getting Help

If you encounter issues not covered here:

1. Check the [Issues](https://github.com/worlddrknss/dotfiles/issues) page
2. Review recent commits for changes
3. Consult the documentation in the `docs/` directory

## Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**: Follow existing code style and conventions
4. **Test thoroughly**: Ensure changes work across different systems
5. **Commit changes**: Use clear, descriptive commit messages
6. **Push to branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**: Provide detailed description of changes

### Contribution Guidelines

- Follow existing code style and formatting
- Add comments for complex configurations
- Update documentation for new features
- Test on multiple operating systems when possible
- Keep commits focused and atomic

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

### Resources

- **Documentation**: See `docs/` directory for detailed documentation
- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/worlddrknss/dotfiles/issues)
- **Discussions**: Join discussions in [GitHub Discussions](https://github.com/worlddrknss/dotfiles/discussions)

### Contact

For questions or support:

- **Email**: [Your Email]
- **GitHub**: [@worlddrknss](https://github.com/worlddrknss)

---

**Last Updated**: 2024
**Maintainer**: worlddrknss
