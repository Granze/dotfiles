source "$HOME/.antigen/antigen.zsh"

antigen-use oh-my-zsh
antigen-bundle arialdomartini/oh-my-git
antigen-bundle command-not-found
antigen-bundle git
antigen-bundle node
antigen-bundle bower
antigen-bundle npm
antigen-bundle sudo
antigen-bundle sublime
antigen-bundle tmuxinator
antigen-bundle gem
antigen-bundle ruby
antigen-bundle rbenv
antigen-bundle rails
antigen-bundle bundler
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-history-substring-search

antigen theme arialdomartini/oh-my-git-themes arialdo-granzestyle

antigen-apply

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

unsetopt correct_all

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias nupd="npm update -g"
alias dins="bower install && npm install"

alias gti="git"
alias s="git status -s"
alias co="git checkout"

alias ains="sudo apt-get install"
alias aupd="sudo apt-get update"
alias aupg="sudo apt-get upgrade"
alias apur="sudo apt-get purge"

alias gw="gulp watch"
alias gb="gulp build"

export EDITOR="vim"
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="$NPM_PACKAGES/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
eval "$(rbenv init -)"

unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
