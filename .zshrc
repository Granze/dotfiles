source "$HOME/.antigen/antigen.zsh"

antigen-use oh-my-zsh
antigen-bundle arialdomartini/oh-my-git
antigen-bundle bower
antigen-bundle command-not-found
antigen-bundle gem
antigen-bundle git
antigen-bundle node
antigen-bundle npm
antigen-bundle sublime
antigen-bundle svn
antigen-bundle vagrant
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
alias gti="git"

alias ains="sudo apt-get install"
alias aupd="sudo apt-get update"
alias aupg="sudo apt-get upgrade"
alias apur="sudo apt-get purge"
alias addrepo="sudo apt-add-repository && sudo apt-get update"

alias cba="cordova build android"
alias cra="cordova run android"

function subl() { command subl "$@" > /dev/null 2>&1 & }
function npmls() { npm ls -g --depth=0 "$@" 2>/dev/null }

export PATH=/opt/android-sdk-linux/platform-tools:$PATH
export PATH=/opt/android-sdk-linux/tools:$PATH
export ANDROID_HOME=/opt/android-sdk-linux/platforms/android-17
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
