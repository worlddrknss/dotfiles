#!/usr/bin/env bash
# Bootstrap these dotfiles on a new machine:
#   1. install Homebrew if missing
#   2. clone the repo to ~/dotfiles (if not already there)
#   3. pick optional package groups, then install core + chosen groups
#   4. back up conflicting files, then `stow .` into $HOME
#   5. install runtimes with mise, then Neovim plugins
#   6. delete this installer (unless it's the copy inside the repo)
#   7. start a fresh zsh with the new config loaded
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/worlddrknss/dotfiles/main/install.sh | bash
#   bash install.sh [--all | --core | --groups a,b]
#
# Packages: Brewfile is the core (always installed); brewfiles/<group>.Brewfile
# are optional. Without flags you get an interactive picker (or core only when
# there's no terminal). The choice is saved for update.sh.
set -euo pipefail

REPO_URL="https://github.com/worlddrknss/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'USAGE'
Usage: install.sh [--all | --core | --groups a,b]

  (no flags)     choose optional package groups interactively
  --all          install every group
  --core         install only the core packages
  --groups a,b   install core plus the listed groups (see brewfiles/)

Change groups later with: ~/dotfiles/update.sh --select
USAGE
}

# Validate options up front (they're applied after the repo is cloned, since
# the group helpers live in it)
ARGS=("$@")
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --all|--core|--select|--groups=*) ;;
    --groups) [[ $# -ge 2 ]] || die "--groups needs a value, e.g. --groups kubernetes,cloud"; shift ;;
    *) usage >&2; die "unknown option: $1" ;;
  esac
  shift
done

# Resolve this script's path before we cd anywhere (empty when piped from curl)
SCRIPT_PATH=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
fi

# ------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------
load_brew() {
  local b
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$b" ]]; then
      eval "$("$b" shellenv)"
      return 0
    fi
  done
  return 1
}

if command -v brew >/dev/null 2>&1 || load_brew; then
  info "Homebrew already installed"
else
  info "Installing Homebrew (you may be asked for your password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew || die "Homebrew installed but brew was not found on PATH"
fi

# ------------------------------------------------------------
# Clone
# ------------------------------------------------------------
command -v git >/dev/null 2>&1 || brew install git

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  info "Dotfiles already cloned at $DOTFILES_DIR"
elif [[ -e "$DOTFILES_DIR" ]]; then
  die "$DOTFILES_DIR exists but is not a git repo; move it aside and re-run"
else
  info "Cloning $REPO_URL to $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# ------------------------------------------------------------
# Package groups (helpers in lib/groups.sh)
# ------------------------------------------------------------
# shellcheck source=lib/groups.sh
source "$DOTFILES_DIR/lib/groups.sh"
set -- "${ARGS[@]+"${ARGS[@]}"}"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --groups) [[ $# -ge 2 ]] || die "--groups needs a value, e.g. --groups kubernetes,cloud"
              MODE=list; REQUESTED="$2"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) parse_group_arg "$1" || { usage >&2; die "unknown option: $1"; } ;;
  esac
  shift
done

resolve_groups select
bundle_selected

# ------------------------------------------------------------
# Stow (back up anything that would block the symlinks)
# ------------------------------------------------------------
backup_conflicts() {
  local conflicts target backup_dir=""
  # Dry run; stow lists each blocking file in its conflict report. It exits
  # non-zero when there are conflicts, which is expected here.
  conflicts=$( (stow -n -t "$HOME" . 2>&1 || true) |
    sed -nE \
      -e 's/.*over existing target (.+) since .*/\1/p' \
      -e 's/.*existing target is not owned by stow: (.+)$/\1/p' \
      -e 's/.*existing target is neither a link nor a directory: (.+)$/\1/p')

  [[ -z "$conflicts" ]] && return 0

  backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    mkdir -p "$backup_dir/$(dirname "$target")"
    mv "$HOME/$target" "$backup_dir/$target"
    warn "backed up ~/$target to $backup_dir/$target"
  done <<<"$conflicts"
}

info "Linking dotfiles into $HOME"
backup_conflicts
stow -v -t "$HOME" . || die "stow failed; see the conflicts above"

# ------------------------------------------------------------
# Runtimes (node, go, bun, ...) — the Neovim language servers need npm and go
# ------------------------------------------------------------
if command -v mise >/dev/null 2>&1; then
  info "Installing runtimes with mise"
  # The global config is a symlink into ~/dotfiles, which mise treats as untrusted
  mise trust "$DOTFILES_DIR/.config/mise/config.toml"
  mise install || warn "mise install failed; run it manually"
  # Put the installed tools on PATH for the Neovim plugin step below
  export PATH="${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims:$PATH"
fi

# ------------------------------------------------------------
# Tool setup
# ------------------------------------------------------------
if command -v kubectl-krew >/dev/null 2>&1; then
  info "Installing kubectl plugins (ctx, ns)"
  kubectl krew install ctx ns >/dev/null 2>&1 || warn "krew plugin install failed; run: kubectl krew install ctx ns"
fi

if command -v tldr >/dev/null 2>&1; then
  tldr --update >/dev/null 2>&1 || warn "tldr cache update failed; run: tldr --update"
fi

# ~/.gitconfig isn't tracked (identity, signing key), so only fill in the
# delta settings when no pager has been chosen yet
if command -v delta >/dev/null 2>&1 && ! git config --global --get core.pager >/dev/null; then
  info "Configuring git to use delta for diffs"
  git config --global core.pager delta
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true
  git config --global delta.line-numbers true
  git config --global merge.conflictStyle zdiff3
fi

# ------------------------------------------------------------
# Neovim plugins (lazy.nvim bootstraps itself on first start)
# ------------------------------------------------------------
info "Installing Neovim plugins"
nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || warn "Neovim plugin install failed; open nvim and run :Lazy sync"

# ------------------------------------------------------------
# Clean up and hand off to zsh
# ------------------------------------------------------------
# Delete a downloaded copy of this installer, but never the one in the repo
if [[ -n "$SCRIPT_PATH" && "$SCRIPT_PATH" != "$DOTFILES_DIR/"* ]]; then
  rm -f "$SCRIPT_PATH"
  info "Removed installer $SCRIPT_PATH"
fi

info "Done! Starting a new zsh with your dotfiles loaded"
# A script can't source ~/.zshrc into the shell that launched it, so replace
# this process with a fresh login zsh. Read from the terminal, not the curl pipe.
if (: </dev/tty) 2>/dev/null; then
  exec zsh -l </dev/tty
else
  info "Open a new terminal (or run: exec zsh) to load the new config"
fi
