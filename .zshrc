source "$HOME/.antigen/antigen.zsh"

antigen-use oh-my-zsh
antigen-bundle arialdomartini/oh-my-git
antigen-bundle command-not-found
antigen-bundle svn
antigen-bundle git
antigen-bundle node
antigen-bundle bower
antigen-bundle npm
antigen-bundle sublime
antigen-bundle sudo
antigen-bundle gem
antigen-bundle ruby
antigen-bundle rails
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
alias nupd="sudo npm update -g"
alias depins="bower install && npm install"

alias gti="git"
alias s="git status -s"
alias co="git checkout"

alias ains="sudo apt-get install"
alias aupd="sudo apt-get update"
alias aupg="sudo apt-get upgrade"
alias apur="sudo apt-get purge"

function subl() { command subl "$@" > /dev/null 2>&1 & }

export PATH=/opt/android-sdk-linux/platform-tools:$PATH
export PATH=/opt/android-sdk-linux/tools:$PATH
export ANDROID_HOME=/opt/android-sdk-linux/platforms/android-17
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export CATALINA_HOME=~/projects/tomcat/
export PATH=$HOME/.node/bin:$PATH
