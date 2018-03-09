if [[ ! -d ~/.antigen ]]; then
  git clone https://github.com/zsh-users/antigen.git ~/.antigen
  source $HOME/.antigen/antigen.zsh
fi

source $HOME/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen-bundle git
antigen-bundle npm
antigen-bundle yarn
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-history-substring-search
antigen-bundle zsh-users/zsh-autosuggestions
antigen-bundle zsh-users/zsh-completions
antigen-bundle mafredri/zsh-async
antigen-bundle sindresorhus/pure

antigen apply

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias gti="git"
alias s="git status -s"
alias co="git checkout"
alias ws="webstorm"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

export PATH=~/.npm-global/bin:$PATH
export PATH="/usr/local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$HOME/.yarn/bin:$PATH"
