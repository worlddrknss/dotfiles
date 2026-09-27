# Packages for these dotfiles. Install with: brew bundle --file ~/dotfiles/Brewfile

# Shell
brew "zsh-autocomplete"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "starship"
brew "zoxide"
brew "fzf"

# CLI tools
brew "bat"
brew "duf"         # disk free space per drive
brew "dust"        # what's using disk space
brew "eza"
brew "fd"          # fast, gitignore-aware find (used by telescope and fzf Opt+C)
brew "figlet"
brew "grep"        # GNU grep, used ahead of the macOS BSD grep
brew "htop"
brew "jq"
brew "openssl@3"   # full OpenSSL 3; macOS /usr/bin/openssl is LibreSSL
brew "ripgrep"
brew "stow"
brew "tealdeer"    # tldr: example-first help pages
brew "tmux"
brew "xh"          # friendlier curl for HTTP APIs
brew "yq"

# Git
brew "gh"
brew "git"
brew "git-delta"   # syntax-highlighted diffs (git pager)
brew "git-filter-repo" # rewrite history (remove files/secrets)
brew "gitleaks"    # scan repos for committed secrets
brew "lazygit"

# Kubernetes
brew "kubernetes-cli"
brew "krew"        # kubectl plugins: ctx and ns (used by kcx/kns aliases)
brew "k9s"
brew "stern"       # tail logs across many pods

# Cloud, infra and secrets
brew "awscli"
brew "opentofu"    # open-source Terraform
brew "sops"        # encrypted secrets files
brew "age"         # encryption backend for sops

# Databases
brew "libpq"       # psql and friends (added to PATH in .zshrc)

# Runtimes (versions in .config/mise/config.toml)
brew "mise"
brew "uv"          # fast Python package/project manager

# Neovim
brew "neovim"
brew "tree-sitter-cli" # builds treesitter parsers
brew "prettier"        # JS/TS/CSS/JSON formatting (conform.nvim)
brew "shfmt"           # shell formatting (conform.nvim)

# Apps: these casks are macOS-only builds (on Linux, install via your distro)
cask "wezterm" if OS.mac?
cask "visual-studio-code" if OS.mac?
cask "caskhub" if OS.mac? # GUI for Homebrew casks; needs macOS 15+
cask "raycast" if OS.mac? # launcher (Spotlight replacement); Apple Silicon only
cask "orbstack" if OS.mac? # Docker + Linux VMs + local Kubernetes; provides the docker CLI (macOS 14+)
cask "postman" if OS.mac? # API client

# Fonts
cask "font-jetbrains-mono-nerd-font" # fallback for the paid DankMono Nerd Font
