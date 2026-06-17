# ============================================================
# Environment / Tooling
# ============================================================
eval "$(/opt/homebrew/bin/mise activate zsh)"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export EDITOR="nvim"

source <(fzf --zsh)

# ============================================================
# History
# ============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY HIST_VERIFY

# ============================================================
# Completion system (must be early)
# ============================================================
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ============================================================
# Autosuggestions (FIRST)
# ============================================================
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ============================================================
# Autocomplete (SECOND)
# ============================================================
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

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
_zsh_autosuggest_start

# ============================================================
# Prompt
# ============================================================
eval "$(starship init zsh)"

# ============================================================
# Syntax Highlighting (MUST BE LAST)
# ============================================================
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  compdef k=kubectl
fi

# ============================================================
# System aliases
# ============================================================
# Cat replacement — no paging, line numbers optional (hide file header/time)
alias cat='bat --paging=never --style=grid,-header'

# Interactive bat — with pager and line numbers
alias b='bat --paging=always --style=grid,numbers --decorations=always'

# FZF with preview
alias f='fzf --height 40% --layout=reverse --preview="bat --style=numbers --color=always {}"'

# Neovim
alias n='nvim'
alias nv='nvim +'

# Zoxide
alias cd='z'
alias j='z'
alias ji='zi'
alias jh='j -h'

# Eza
alias ls='eza -alh --group-directories-first --git'

# Ripgrep
alias grep='rg --color=auto'
alias fgrep='rg --fixed-strings --color=auto'
alias egrep='rg --color=auto --regexp'
alias rgi='rg --ignore-case --color=auto'
alias rgf='rg --files'
alias rgn='rg --line-number'

# ============================================================
# Functions
# ============================================================
csh() {
  local host port
  host=$(
    awk '
      $1 == "Host" {
        for (i = 2; i <= NF; i++) {
          if ($i !~ "[*?]") print $i
        }
      }
    ' ~/.ssh/config | sort -u | fzf --prompt="SSH > "
  )
  [[ -z "$host" ]] && return
  local cfg_port
  cfg_port=$(awk -v host="$host" '
    $1 == "Host" { found = 0; for (i = 2; i <= NF; i++) if ($i == host) found = 1 }
    found && $1 == "Port" { print $2; exit }
  ' ~/.ssh/config)
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
    if nc -z -w 5 "$real_host" "$try_port" 2>/dev/null; then
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
      cat "$errfile" >&2
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
  if [[ -z "$line" ]]; then
    echo "Usage: rmknown <line_number> [known_hosts_file]" >&2
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
bindkey '^I' autosuggest-accept

# Toggle K8s visibility widget
bindkey '\e[1;P1' toggle_k8s_widget

# ============================================================
# Cosmetic
# ============================================================
# [[ -o interactive ]] && fastfetch
# [[ -o interactive ]] && figlet "WorldDrknss"
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/worlddrknss/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# ============================================================
# Zoxide (must be initialized last)
# ============================================================
eval "$(zoxide init zsh)"

# ============================================================
# Local overrides (machine-specific, untracked)
# ============================================================
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"