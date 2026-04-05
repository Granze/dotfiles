#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#
setopt AUTO_CD

# case-insensitive completion and globbing
setopt NO_CASE_GLOB
fpath=(~/.zsh/zsh-completions/src $fpath)

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:~/.local/kitty.app/bin   

alias ls="eza --icons --group-directories-first"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias gti="git"
alias s="git status -s"
alias co="git checkout"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'

# Autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf - fuzzy search (history CTRL+R, file CTRL+T)
source <(fzf --zsh)

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
