#!/usr/bin/env bash
# Keep an existing setup current:
#   1. pull the latest dotfiles (skipped if the repo has local changes)
#   2. install new entries for core + your package groups, then brew upgrade
#   3. re-stow to link any new files
#   4. install/upgrade mise runtimes
#   5. update Neovim plugins (lazy.nvim) and treesitter parsers
#   6. refresh tldr pages and krew plugins
#
# Usage: ~/dotfiles/update.sh [--select | --all | --core | --groups a,b]
#   (no flags)   update core + the groups saved by install.sh
#   --select     re-open the group picker to add/remove groups
#   --all        use every group; --core: core only; --groups a,b: those groups
# Deselecting a group stops updating it; it doesn't uninstall anything.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

cd "$DOTFILES_DIR"

usage() { sed -n 's/^# \{0,1\}//; /^Usage:/,/uninstall anything/p' "$0"; }
ORIG_ARGS=("$@")
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --all|--core|--select|--groups=*) ;;
    --groups) [[ $# -ge 2 ]] || die "--groups needs a value, e.g. --groups kubernetes,cloud"; shift ;;
    *) usage >&2; die "unknown option: $1" ;;
  esac
  shift
done

# ------------------------------------------------------------
# Dotfiles
# ------------------------------------------------------------
if [[ -n "$(git status --porcelain)" ]]; then
  warn "local changes in $DOTFILES_DIR; skipping git pull (commit or stash, then re-run)"
else
  info "Pulling latest dotfiles"
  git pull --ff-only || warn "git pull failed (diverged from origin?); continuing with local copy"
fi

# ------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------
if command -v brew >/dev/null 2>&1; then
  info "Updating Homebrew"
  brew update
  # After the pull, so new groups and new entries in brewfiles/ are picked up
  # shellcheck source=lib/groups.sh
  source "$DOTFILES_DIR/lib/groups.sh"
  set -- "${ORIG_ARGS[@]+"${ORIG_ARGS[@]}"}"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --groups) MODE=list; REQUESTED="$2"; shift ;;
      *) parse_group_arg "$1" ;;
    esac
    shift
  done
  resolve_groups saved
  bundle_selected
  info "Upgrading Homebrew packages"
  brew upgrade || warn "brew upgrade had failures; continuing"
else
  warn "brew not found; run install.sh first"
fi

# ------------------------------------------------------------
# Links
# ------------------------------------------------------------
info "Linking any new dotfiles"
stow -t "$HOME" . || warn "stow reported conflicts; move the listed files aside (or run install.sh) and re-run"

# ------------------------------------------------------------
# Runtimes
# ------------------------------------------------------------
if command -v mise >/dev/null 2>&1; then
  info "Updating mise runtimes"
  mise install || warn "mise install failed"
  mise upgrade || warn "mise upgrade failed"
  export PATH="${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims:$PATH"
fi

# ------------------------------------------------------------
# Neovim
# ------------------------------------------------------------
if command -v nvim >/dev/null 2>&1; then
  info "Updating Neovim plugins"
  nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || warn "Lazy sync failed; open nvim and run :Lazy sync"
  info "Updating treesitter parsers"
  nvim --headless -c "lua require('nvim-treesitter').update():wait(300000)" -c qa >/dev/null 2>&1 ||
    warn "treesitter update failed; open nvim and run :TSUpdate"
fi

# ------------------------------------------------------------
# Tool data
# ------------------------------------------------------------
if command -v tldr >/dev/null 2>&1; then
  tldr --update >/dev/null 2>&1 || warn "tldr cache update failed"
fi

if command -v kubectl-krew >/dev/null 2>&1; then
  info "Upgrading kubectl plugins"
  kubectl krew upgrade >/dev/null 2>&1 || warn "krew upgrade failed"
fi

# ------------------------------------------------------------
# Summary
# ------------------------------------------------------------
if [[ -n "$(git status --porcelain -- .config/nvim/lazy-lock.json)" ]]; then
  info "Plugin versions changed: review and commit .config/nvim/lazy-lock.json"
fi
info "Done. Run: exec zsh (to reload the shell); the dotup shell function does both steps"
