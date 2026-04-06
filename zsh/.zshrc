# change diectory without typing 'cd'
setopt AUTO_CD

# case-insensitive completion and globbing
setopt NO_CASE_GLOB

# allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# history settings
HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# Homebrew environment (must be early — needed by brew --prefix below)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null

# zsh-completions via Homebrew
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# NVM (Node Version Manager) setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Kitty terminal setup
export PATH=$PATH:~/.local/kitty.app/bin   

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Git aliases
alias gti="git"
alias s="git status -s"
alias co="git checkout"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# ls alias with icons and grouping directories first
alias ls="eza --icons --group-directories-first"

# Use bat instead of cat for better syntax highlighting and paging
alias cat="bat --paging=never"

# Open the commit message in the editor with a pre-filled template
_gcom_widget() {
  BUFFER='git commit -m ""'
  CURSOR=$(( ${#BUFFER} - 1 ))
  zle redisplay
}
zle -N _gcom_widget
bindkey '^[g' _gcom_widget  # Alt+G

# Autocomplete
autoload -Uz compinit && compinit  # called once, after FPATH is fully set
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'

# Autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# fzf - fuzzy search (history CTRL+R, file CTRL+T)
source <(fzf --zsh)

# zoxide - smarter cd and Startship - prompt
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
