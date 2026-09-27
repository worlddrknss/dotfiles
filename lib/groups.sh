# Package-group helpers shared by install.sh and update.sh (sourced, not run).
#
# Brewfile is the core (always installed). Each brewfiles/<group>.Brewfile is
# an optional group with two header lines:
#   # @desc Label shown in the picker (no commas: gum splits --selected on them)
#   # @default on|off
#
# Callers set DOTFILES_DIR and define info/warn/die before sourcing.

GROUPS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/groups"

all_groups() {
  local f
  for f in "$DOTFILES_DIR"/brewfiles/*.Brewfile; do
    basename "$f" .Brewfile
  done
}
group_desc() { sed -n 's/^# @desc //p' "$DOTFILES_DIR/brewfiles/$1.Brewfile"; }
group_default_on() { grep -q '^# @default on' "$DOTFILES_DIR/brewfiles/$1.Brewfile"; }
has_tty() { (: </dev/tty) 2>/dev/null; }
saved_groups() { [[ -f "$GROUPS_FILE" ]] && cat "$GROUPS_FILE"; }

# Interactive checklist (gum). Preselects the saved choice, else the defaults.
pick_groups() {
  command -v gum >/dev/null 2>&1 || brew install gum >/dev/null

  local g label options=() preselect=() previous=""
  [[ -f "$GROUPS_FILE" ]] && previous=" $(tr '\n' ' ' <"$GROUPS_FILE") "
  for g in $(all_groups); do
    label="$(group_desc "$g")"
    options+=("$label|$g")
    if [[ -f "$GROUPS_FILE" ]]; then
      [[ "$previous" == *" $g "* ]] && preselect+=("$label")
    elif group_default_on "$g"; then
      preselect+=("$label")
    fi
  done

  local IFS=,
  gum choose --no-limit --label-delimiter="|" \
    --header="Core shell + Neovim packages are always installed. Optional groups (x to toggle, enter to confirm):" \
    --selected="${preselect[*]}" \
    --cursor.foreground="#4dd44d" --selected.foreground="#4dd44d" \
    --header.foreground="#a3a3a3" --item.foreground="#d9d9d9" \
    "${options[@]}" </dev/tty
}

# Parse --all / --core / --groups a,b / --select into MODE and REQUESTED.
# Returns 1 for an argument it doesn't know (caller decides what to do).
MODE=""
REQUESTED=""
parse_group_arg() {
  case "$1" in
    --all)      MODE=all ;;
    --core)     MODE=core ;;
    --select)   MODE=select ;;
    --groups=*) MODE=list; REQUESTED="${1#*=}" ;;
    *) return 1 ;;
  esac
}

# Resolve MODE into SELECTED (newline-separated group names).
#   default_mode: what "" means for this script (install: pick, update: saved)
resolve_groups() {
  local default_mode=$1 g
  local mode="${MODE:-$default_mode}"
  case "$mode" in
    all)  SELECTED="$(all_groups)" ;;
    core) SELECTED="" ;;
    list)
      SELECTED=""
      for g in ${REQUESTED//,/ }; do
        [[ -f "$DOTFILES_DIR/brewfiles/$g.Brewfile" ]] ||
          die "unknown group '$g' (available: $(all_groups | tr '\n' ' '))"
        SELECTED+="$g"$'\n'
      done
      ;;
    select)
      if has_tty; then
        SELECTED="$(pick_groups)" || die "selection cancelled"
      else
        info "No terminal for the picker; installing core only (use --all or --groups to add more)"
        SELECTED=""
      fi
      ;;
    saved)
      if [[ -f "$GROUPS_FILE" ]]; then
        SELECTED="$(saved_groups)"
      else
        # Setups from before groups existed had everything installed
        info "No saved group choice; updating all groups (run with --select to choose)"
        SELECTED="$(all_groups)"
      fi
      ;;
  esac

  mkdir -p "$(dirname "$GROUPS_FILE")"
  printf '%s\n' $SELECTED >"$GROUPS_FILE"
}

# brew bundle core + each selected group; one failure doesn't stop the rest
bundle_selected() {
  local g
  info "Installing core packages"
  brew bundle --file "$DOTFILES_DIR/Brewfile" || warn "some core packages failed; continuing"
  for g in $SELECTED; do
    info "Installing group: $g"
    brew bundle --file "$DOTFILES_DIR/brewfiles/$g.Brewfile" ||
      warn "some packages in '$g' failed (e.g. an app installed outside Homebrew); continuing"
  done
}
