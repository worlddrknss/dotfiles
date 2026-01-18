# ============================================================
# Environment / Tooling
# ============================================================
eval "$(/Users/worlddrknss/.local/bin/mise activate zsh)"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export EDITOR="nvim"

eval "$(zoxide init zsh)"
source <(fzf --zsh)

# ============================================================
# Completion system (must be early)
# ============================================================
autoload -Uz compinit
compinit

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
# Cat replacement — no paging, line numbers optional
alias cat='bat --paging=never --style=grid --decorations=always'

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
  local host
  host=$(
    awk '
      $1 == "Host" {
        for (i = 2; i <= NF; i++) {
          if ($i !~ "[*?]") print $i
        }
      }
    ' ~/.ssh/config | sort -u | fzf --prompt="SSH > "
  )
  [[ -n "$host" ]] && ssh "$host"
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
[[ -o interactive ]] && figlet "WorldDrknss"
