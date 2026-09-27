# ============================================================
# Environment / Tooling
# ============================================================
if [[ -x /opt/homebrew/bin/mise ]]; then
  eval "$(/opt/homebrew/bin/mise activate zsh)"
fi

# Keep PATH free of duplicates (nested shells, mise re-activation)
typeset -U path PATH

path=(
  /opt/homebrew/opt/grep/libexec/gnubin(N)  # GNU grep over BSD grep (brew install grep)
  /opt/homebrew/opt/libpq/bin(N)
  ${KREW_ROOT:-$HOME/.krew}/bin
  $path
  $HOME/.lmstudio/bin(N)
)
export EDITOR="nvim"
export VISUAL="$EDITOR"

# ============================================================
# History
# ============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY HIST_VERIFY
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_REDUCE_BLANKS
setopt INTERACTIVE_COMMENTS  # allow '# comments' in pasted commands

# ============================================================
# Autosuggestions (FIRST)
# ============================================================
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ============================================================
# Autocomplete (SECOND) — runs compinit itself, so only call it as a fallback
# ============================================================
if [[ -r /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
  source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
else
  autoload -Uz compinit
  # Full rebuild once a day, otherwise skip the security check (-C)
  () {
    if [[ $# -gt 0 ]]; then compinit; else compinit -C; fi
  } ~/.zcompdump(N.mh+24)
fi

if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

# ------------------------------------------------------------
# Disable autocomplete for zoxide (j / z) to let autosuggestions work
# ------------------------------------------------------------
zstyle ':autocomplete:*:*:cd:*' disabled yes
zstyle ':autocomplete:*:*:z:*' disabled yes
zstyle ':autocomplete:*:*:j:*' disabled yes

# Restore autosuggestions after widget overrides
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244,bold'
if (( $+functions[_zsh_autosuggest_start] )); then
  _zsh_autosuggest_start
fi

# ============================================================
# Prompt
# ============================================================
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# ============================================================
# Kubernetes
# ============================================================
alias k="kubectl"
alias kcx="k ctx"
alias kc="k ctx -c"
alias kns="k ns"
alias kn="k ns -c"
alias kg="k get"
alias kd="k describe"
alias kgp="k get pods"
alias kga="k get all"
alias kl="k logs -f"
alias kex="k exec -it"
alias kaf="k apply -f"
alias kdel="k delete"

if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  compdef k=kubectl
fi

# ============================================================
# System aliases
# ============================================================
# Bat — each alias only if the tool exists, so a fresh machine keeps working
if command -v bat &> /dev/null; then
  # Cat replacement — no paging, no file header
  alias cat='bat --paging=never --style=grid,-header'
  # Interactive bat — with pager and line numbers
  alias b='bat --paging=always --style=grid,numbers --decorations=always'
fi

# FZF with preview (directories get a tree listing instead of a bat error)
alias f='fzf --height 40% --layout=reverse --preview="[[ -d {} ]] && eza --tree --level=2 --color=always {} || bat --style=numbers --color=always {}"'

# Neovim
alias n='nvim'
alias nv='nvim +'

# Eza
if command -v eza &> /dev/null; then
  # eza reads file names from a non-tty stdin, so with no path it prints
  # nothing in loops/pipelines/ssh. Default the path to '.'.
  _eza() {
    local arg
    for arg in "$@"; do
      [[ $arg != -* ]] && { eza "$@"; return; }
    done
    eza "$@" .
  }
  alias ls='_eza -alh --group-directories-first --git'
  alias l='_eza -1 --group-directories-first'
  alias lt='_eza --tree --level=2 --group-directories-first --git-ignore'
fi

# Grep — keep real grep: rg reinterprets grep flags (-r is --replace, -E is --encoding)
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

# Ripgrep
alias rgi='rg --ignore-case'
alias rgf='rg --files'
alias rgn='rg --line-number'

# ============================================================
# Functions
# ============================================================
csh() {
  local ssh_config="$HOME/.ssh/config"
  if [[ ! -r "$ssh_config" ]]; then
    echo "csh: missing or unreadable $ssh_config" >&2
    return 1
  fi

  local host port
  host=$(
    awk '
      $1 == "Host" {
        for (i = 2; i <= NF; i++) {
          if ($i !~ "[*?]") print $i
        }
      }
    ' "$ssh_config" | sort -u | fzf --prompt="SSH > "
  )
  [[ -z "$host" ]] && return
  local cfg_port
  cfg_port=$(awk -v host="$host" '
    $1 == "Host" { found = 0; for (i = 2; i <= NF; i++) if ($i == host) found = 1 }
    found && $1 == "Port" { print $2; exit }
  ' "$ssh_config")
  : "${cfg_port:=22}"
  read -r "port?Port (${cfg_port}): "
  : "${port:=$cfg_port}"

  if [[ "$port" == "22" ]]; then
    _csh_connect "$host" 22
    return
  fi

  local real_host
  real_host=$(ssh -G "$host" 2>/dev/null | awk '$1=="hostname"{print $2; exit}')
  : "${real_host:=$host}"

  local attempt try_port
  for attempt in 0 1 2 3; do
    try_port=$((port + attempt))
    # -G bounds the TCP connect itself; -w only covers idle time on an
    # already-established connection, so a filtered port would otherwise
    # hang for the ~75s kernel connect timeout.
    if nc -z -G 3 -w 3 "$real_host" "$try_port" 2>/dev/null; then
      _csh_connect "$host" "$try_port"
      return
    fi
    echo "csh: port $try_port unreachable, trying next..." >&2
  done

  echo "csh: failed to connect to $host on ports $port-$((port + 3))" >&2
  return 1
}

# Connect, and if ssh fails because a rotated host reused an IP with a new
# host key, offer to drop the stale known_hosts line and retry. Loops since
# a host can have a separate stale entry per key algorithm (RSA/ECDSA/ED25519).
_csh_connect() {
  local host=$1 port=$2
  local -a ssh_args=("$host")
  [[ "$port" != "22" ]] && ssh_args=(-p "$port" "$host")

  local errfile rc offending kh_file kh_line reply attempt
  for attempt in 1 2 3 4 5; do
    errfile=$(mktemp)
    ssh "${ssh_args[@]}" 2>"$errfile"
    rc=$?

    if (( rc == 0 )); then
      rm -f "$errfile"
      return 0
    fi

    offending=$(command grep -oE 'Offending [A-Za-z0-9_-]+ key in [^:]+:[0-9]+' "$errfile" | tail -1)
    if [[ -z "$offending" ]]; then
      command cat "$errfile" >&2
      rm -f "$errfile"
      return $rc
    fi

    kh_file=${offending#*in }
    kh_file=${kh_file%:*}
    kh_line=${offending##*:}
    echo
    echo "csh: stale host key for $host"
    echo "     $(sed -n "${kh_line}p" "$kh_file")"
    read -r "reply?Remove line $kh_line from $kh_file and retry? [y/N] "
    rm -f "$errfile"
    if [[ "$reply" != [yY] ]]; then
      return $rc
    fi
    sed -i '' "${kh_line}d" "$kh_file"
  done

  echo "csh: still failing after removing stale key(s) for $host" >&2
  return 1
}

# Quickly delete a stale entry from known_hosts by line number, e.g. after
# "Offending RSA key in /Users/you/.ssh/known_hosts:42" in an ssh error.
rmknown() {
  local line=$1 file=${2:-$HOME/.ssh/known_hosts}
  if [[ "$line" != <-> ]]; then
    echo "Usage: rmknown <line_number> [known_hosts_file]" >&2
    return 1
  fi
  if [[ ! -w "$file" ]]; then
    echo "rmknown: cannot write $file" >&2
    return 1
  fi
  echo "Removing: $(sed -n "${line}p" "$file")"
  sed -i '' "${line}d" "$file"
}

toggle_k8s() {
  if [[ -n "$STARSHIP_K8S_VISIBLE" ]]; then
    unset STARSHIP_K8S_VISIBLE
  else
    export STARSHIP_K8S_VISIBLE=1
  fi
  zle reset-prompt
}

zle -N toggle_k8s_widget toggle_k8s

# ============================================================
# Keybindings
# ============================================================
# Tab → accept autosuggestion (Fish-style)
if (( $+widgets[autosuggest-accept] )); then
  bindkey '^I' autosuggest-accept
fi

# Toggle K8s visibility widget
bindkey '\e[1;P1' toggle_k8s_widget

# ============================================================
# Cosmetic
# ============================================================
# [[ -o interactive ]] && fastfetch
# [[ -o interactive ]] && figlet "WorldDrknss"
# ============================================================
# Zoxide (after everything that touches chpwd/precmd)
# ============================================================
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias j='z'
  alias ji='zi'
  alias jl='zoxide query -ls'
fi

# ============================================================
# Local overrides (machine-specific, untracked)
# ============================================================
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ============================================================
# Syntax Highlighting (MUST BE LAST — wraps every widget defined above)
# ============================================================
if [[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi