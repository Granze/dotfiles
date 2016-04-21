source "$HOME/.antigen/antigen.zsh"

antigen-use oh-my-zsh
antigen-bundle git
antigen-bundle node
antigen-bundle sudo
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-history-substring-search

antigen-apply

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

#unsetopt correct_all

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias gti="git"
alias s="git status -s"
alias co="git checkout"

alias ains="sudo apt-get install"
alias aupd="sudo apt-get update"
alias aupg="sudo apt-get upgrade"
alias apur="sudo apt-get purge"

export EDITOR="gedit"
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"
export PATH=~/.npm-global/bin:$PATH
export NVM_SYMLINK_CURRENT=true
export NVM_DIR="/home/granze/.nvm"
export PATH=$PATH:$NVM_DIR/current/bin
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

