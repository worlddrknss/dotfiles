# Dotfiles

> An opinionated macOS dev setup: Zsh, Neovim, WezTerm and a curated set of CLI tools, installed with one command.

[![Maintenance](https://img.shields.io/badge/maintained-yes-green.svg)](https://github.com/worlddrknss/dotfiles)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Tools](#tools)
- [Keybindings and Aliases](#keybindings-and-aliases)
- [Repository Structure](#repository-structure)
- [Usage](#usage)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Support](#support)

## Overview

This is my personal, opinionated development environment for macOS. It makes choices for you
(a custom dark theme, Neovim as the editor, modern replacements for `ls`/`cat`/`find`, Kubernetes
shortcuts baked in) rather than trying to suit everyone. Use it as-is, or fork it and change what
doesn't fit.

`install.sh` takes a fresh Mac to a working setup; `update.sh` keeps it current.

## Features

- **Shell**: Zsh with Starship prompt, autosuggestions, as-you-type completion, syntax highlighting, fzf and zoxide
- **Editor**: Neovim with LSP (Bash, CSS, JS/TS, Go, Lua), treesitter, Telescope, format-on-save and git integration; VS Code installed alongside
- **Terminal**: WezTerm with splits and pane navigation
- **Theme**: *Drknss*, an old-school black, grey, red and green palette shared by WezTerm (`wezterm.lua`), the Starship prompt (`starship.toml`) and Neovim (`colors/drknss.lua`). The terminal is 70% opaque black with blur, and Neovim's background is transparent so it shows through
- **CLI tools**: `eza`, `bat`, `ripgrep`, `fd`, GNU grep, OpenSSL 3, `delta`, `lazygit`, `xh`, `tldr` and more
- **Kubernetes**: `kubectl` aliases, `k9s`, `stern`, krew `ctx`/`ns`, and a prompt toggle for the current context
- **Runtimes**: node, go, bun, python and rust managed by mise
- **Apps**: WezTerm, VS Code, Raycast, OrbStack (Docker and local Kubernetes), Postman, DBeaver, ngrok, LM Studio, Claude Code and CaskHub (a GUI for Homebrew casks), plus optional personal and maker app groups
- **Cloud and secrets**: `awscli`, OpenTofu, `sops` + `age`, `gitleaks`
- **One-command setup and updates**: everything is in a `Brewfile`, linked with GNU Stow

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

Packages are split into a required core and optional groups:

| File | Group | Default |
| --- | --- | --- |
| [`Brewfile`](Brewfile) | **core**: zsh plugins, Starship, fzf, zoxide, eza, bat, ripgrep, fd, GNU grep, git, stow, mise, Neovim | always |
| [`brewfiles/neovim-extras.Brewfile`](brewfiles/neovim-extras.Brewfile) | prettier, shfmt, lazygit, delta | on |
| [`brewfiles/cli.Brewfile`](brewfiles/cli.Brewfile) | htop, dust, duf, tldr, xh, jq, yq, gh, uv, OpenSSL 3 | on |
| [`brewfiles/fonts.Brewfile`](brewfiles/fonts.Brewfile) | JetBrainsMono Nerd Font | on |
| [`brewfiles/kubernetes.Brewfile`](brewfiles/kubernetes.Brewfile) | kubectl, krew, k9s, stern, Freelens | off |
| [`brewfiles/cloud.Brewfile`](brewfiles/cloud.Brewfile) | awscli, OpenTofu, sops + age, gitleaks, git-filter-repo, psql | off |
| [`brewfiles/apps.Brewfile`](brewfiles/apps.Brewfile) | WezTerm, VS Code, Raycast, OrbStack, Postman, DBeaver, ngrok, LM Studio, CaskHub, Claude Code | off |
| [`brewfiles/personal.Brewfile`](brewfiles/personal.Brewfile) | Chrome, Opera GX, Discord, Signal, Obsidian, Keeper, Proton Mail Bridge, AppCleaner | off |
| [`brewfiles/maker.Brewfile`](brewfiles/maker.Brewfile) | balenaEtcher, Bambu Studio, Raspberry Pi Imager | off |

`install.sh` lets you pick groups; all configs are linked either way, and the shell skips
anything that isn't installed. To add a group, drop a new `brewfiles/<name>.Brewfile` with
`# @desc ...` and `# @default on|off` header lines and it shows up in the picker.

### Runtimes

Language runtimes (node, go, bun, python, rust, ...) are managed by [mise](https://mise.jdx.dev/)
from [`.config/mise/config.toml`](.config/mise/config.toml). The Neovim language servers need
`npm` and `go`, so run `mise install` after linking the dotfiles (`install.sh` does this).

### Shell frameworks

Don't install [Oh My Zsh](https://ohmyz.sh/) (or Prezto and similar frameworks) alongside these
dotfiles. This setup already loads its own plugins, and a framework breaks it:

- Its installer replaces `~/.zshrc`, removing the stow symlink to this repo's `.zshrc`
- It runs `compinit` itself, which zsh-autocomplete requires nothing else to do
- Its theme competes with the Starship prompt
- Its bundled aliases and plugins override the ones here (`ls`, `grep`, git, autosuggestions)

If Oh My Zsh is already installed, run `uninstall_oh_my_zsh`, then re-link with
`cd ~/dotfiles && stow .` (or re-run `install.sh`, which backs up conflicting files first).

## Installation

### Quick install (new machine)

```bash
curl -fsSL https://raw.githubusercontent.com/worlddrknss/dotfiles/main/install.sh | bash
```

[`install.sh`](install.sh) will:

1. Install Homebrew if it isn't already installed
2. Clone this repo to `~/dotfiles` (skipped if it's already there)
3. Show a checklist of optional package groups (`x` to toggle, `enter` to confirm), then
   install the core packages plus the groups you picked
4. Move any existing files that would be overwritten to `~/.dotfiles-backup/<timestamp>/`
5. Run `stow .` to symlink everything into your home directory
6. Install runtimes with `mise install`, then Neovim plugins
7. Delete the downloaded installer and start a new `zsh` with the config loaded

Skip the checklist with flags (pass them after `bash -s --` when piping from curl):

```bash
bash install.sh --all                      # every group
bash install.sh --core                     # core only
bash install.sh --groups kubernetes,cloud  # core + these groups
curl -fsSL https://raw.githubusercontent.com/worlddrknss/dotfiles/main/install.sh | bash -s -- --all
```

Without a terminal (e.g. in CI) and without flags, only the core is installed. Your choice
is saved to `~/.config/dotfiles/groups` for `update.sh`.

It's safe to re-run. The copy of `install.sh` inside `~/dotfiles` is never deleted.

> WezTerm uses the paid **DankMono Nerd Font** if it's installed, and falls back to
> **JetBrainsMono Nerd Font** (installed by the `Brewfile`) otherwise.

### Manual installation

```bash
git clone https://github.com/worlddrknss/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .          # symlink everything into $HOME
exec zsh        # reload the shell
```

Files listed in [`.stow-local-ignore`](.stow-local-ignore) (README, install.sh, update.sh, Brewfile, brewfiles/, lib/, git files) are not linked.

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

## Tools

Installed by the `Brewfile` alongside the core shell setup:

| Tool | Use it for |
| --- | --- |
| `k9s` | Full-screen Kubernetes manager: pods, logs, shells, port-forwards |
| `stern <name>` | Follow logs from every matching pod at once |
| `lazygit` (`lg`) | Full-screen git: stage parts of files, rebase, resolve conflicts |
| `delta` | Syntax-highlighted `git diff` (set as git's pager by `install.sh`; `n`/`N` jump between files) |
| `fd` | Fast `find` that respects `.gitignore` |
| `htop` | Process viewer |
| `dust` / `duf` | What's using disk space / free space per drive |
| `tldr <cmd>` | Short, example-first help pages |
| `xh` | HTTP client: `xh POST api.example.com/items name=foo` |
| `gh`, `jq`, `yq` | GitHub CLI, JSON and YAML processing, terminal multiplexer |
| `openssl` | OpenSSL 3 (put ahead of the LibreSSL build that ships with macOS) |

## Keybindings and Aliases

Only custom bindings are listed; tool defaults still apply.

### WezTerm

| Keys | Action |
| --- | --- |
| `Cmd+D` | Split pane side by side |
| `Cmd+Shift+D` | Split pane top/bottom |
| `Cmd+Opt+Arrow` | Move between panes |
| `Cmd+Shift+Enter` | Zoom/unzoom current pane |
| `Cmd+W` | Close current pane (no confirmation) |
| `Cmd+X` | Clear screen and scrollback |
| `Cmd+K` | Toggle Kubernetes context in the prompt |
| `Opt+Left` / `Opt+Right` | Jump back/forward one word |

### Zsh

| Keys | Action |
| --- | --- |
| `Tab` | Accept the grey autosuggestion, or complete if there is none |
| `Ctrl+R` | Fuzzy search history (fzf) |
| `Ctrl+T` | Fuzzy insert a file path (fzf) |
| `Opt+C` | Fuzzy `cd` into a subdirectory (fzf, via `fd`) |

Completion matches hidden files without the leading dot and falls back to case-insensitive and substring matches, so `~/zs` finds `~/.zshrc`.

### Neovim

Leader is `Space`.

| Keys | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Open buffers |
| `<leader>fh` | Help tags |
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `]h` / `[h` | Next/previous git hunk |
| `<leader>hp` | Preview git hunk |
| `<leader>hr` | Reset git hunk |
| `<leader>hb` | Git blame for the current line |
| `<leader>gg` | Open lazygit |
| `<leader>gl` | Lazygit log |

Press `Space` and pause to see available keys (which-key). Files are formatted on save
(gofmt, prettier, shfmt, otherwise the LSP); Lua files are skipped. Yanks use the system clipboard.

LSP uses Neovim's built-in defaults: `K` hover, `grn` rename, `gra` code action, `grr` references, `gri` implementation, `[d` / `]d` previous/next diagnostic.

### Shell aliases

| Alias | Runs |
| --- | --- |
| `ls` | `eza -alh --group-directories-first --git` |
| `l` | `eza -1` (names only) |
| `lt` | `eza --tree --level=2` (skips gitignored files) |
| `cat` | `bat` without paging |
| `b` | `bat` with pager and line numbers |
| `f` | `fzf` with file/directory preview |
| `n` / `nv` | `nvim` / `nvim` at the last line |
| `lg` | `lazygit` |
| `sudo n <file>` | `sudoedit` in your Neovim (your config, written back as root) |
| `cd` / `j` | `z` (zoxide smart jump) |
| `ji` | `zi` (interactive zoxide picker) |
| `jl` | List zoxide directories with scores |
| `grep`, `egrep`, `fgrep` | GNU grep with color |
| `rgi` / `rgf` / `rgn` | `rg` ignore-case / list files / with line numbers |
| `csh` | Pick an SSH host from `~/.ssh/config` with fzf and connect |
| `rmknown <line>` | Delete a line from `~/.ssh/known_hosts` |

### Kubernetes aliases

| Alias | Runs |
| --- | --- |
| `k` | `kubectl` |
| `kcx` / `kc` | `kubectl ctx` / show current context |
| `kns` / `kn` | `kubectl ns` / show current namespace |
| `kg` / `kd` | `kubectl get` / `describe` |
| `kgp` / `kga` | `kubectl get pods` / `get all` |
| `kl` | `kubectl logs -f` |
| `kex` | `kubectl exec -it` |
| `kaf` | `kubectl apply -f` |
| `kdel` | `kubectl delete` |

`kcx`/`kns` need the krew `ctx` and `ns` plugins.

## Repository Structure

```text
dotfiles/
├── README.md              # This file
├── install.sh             # Bootstrap script for new machines
├── update.sh              # Pull, upgrade packages/runtimes/plugins, re-stow
├── Brewfile               # Core Homebrew packages
├── brewfiles/             # Optional package groups (picked in install.sh)
├── lib/groups.sh          # Group picker shared by install.sh and update.sh
├── .gitignore             # Ignores .DS_Store and Brewfile.lock.json
├── .stow-local-ignore     # Files stow should not link
├── .stowrc               # Stow options (--no-folding: link files, not whole folders)
├── .zshrc                 # Zsh configuration
├── .config/               # Neovim, WezTerm, Starship and mise configurations
└── .git/                  # Git repository metadata
```

## Usage

### Daily Operations

After installation, the dotfiles work automatically. No additional steps are required for normal usage.

### Updating

```bash
~/dotfiles/update.sh            # core + your saved groups
~/dotfiles/update.sh --select   # re-open the checklist to add or remove groups
exec zsh
```

[`update.sh`](update.sh) will:

1. Pull the latest dotfiles (skipped if you have uncommitted changes, so it never merges over your work)
2. Install anything new in the core `Brewfile` and your groups, then `brew upgrade`
3. Run `stow .` to link newly added files
4. Run `mise install` and `mise upgrade`
5. Update Neovim plugins (`Lazy sync`) and treesitter parsers
6. Refresh `tldr` pages and krew plugins

It also accepts `--all`, `--core` and `--groups a,b`. Unticking a group stops updating it but
doesn't uninstall anything. If plugin versions changed, commit the updated
`.config/nvim/lazy-lock.json`.

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
# Re-run the installer: it moves conflicting files to ~/.dotfiles-backup/ and re-stows
bash ~/dotfiles/install.sh

# Or by hand: back up the file, then stow
mv ~/.zshrc ~/.zshrc.backup
cd ~/dotfiles && stow .
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

