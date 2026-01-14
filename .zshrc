source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
eval "$(starship init zsh)"
eval "$(/Users/worlddrknss/.local/bin/mise activate zsh)"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
figlet -f slant "WorldDrknss"

# kubernetes
alias k="kubectl"
alias kcx="k ctx"
alias kc="k ctx -c"
alias kns="k ns"
alias kn="k ns -c"
alias kg="k get"
alias kd="k describe"

# kubectl autocompletion
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  # Enable completion for 'k' alias
  compdef k=kubectl
fi

# system commands
alias b="bat"
alias f="fzf"
alias n="nvim"
alias j="z"
alias ji="zi"
alias ls="eza"

# commands
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
    export STARSHIP_K8S_VISIBLE="1"
  fi
  zle && zle reset-prompt
}

zle -N toggle_k8s_widget toggle_k8s
bindkey '\e[1;P1' toggle_k8s_widget