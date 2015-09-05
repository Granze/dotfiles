source "$HOME/.antigen/antigen.zsh"

antigen-use oh-my-zsh
antigen-bundle git
antigen-bundle node
antigen-bundle sudo
antigen-bundle lein
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-history-substring-search

#antigen theme arialdomartini/oh-my-git-themes arialdo-granzestyle

antigen-apply

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

unsetopt correct_all

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

export EDITOR="vim"
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="$NPM_PACKAGES/bin:$PATH"
export PATH="$PATH:/opt/google_appengine/"
#export PATH="$HOME/.rbenv/bin:$PATH"
#export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
#eval "$(rbenv init -)"
export NVM_SYMLINK_CURRENT=true
export NVM_DIR="/home/granze/.nvm"
export PATH=$PATH:$NVM_DIR/current/bin
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

