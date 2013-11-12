# Antigen installation
# cd ~; git clone https://github.com/zsh-users/antigen.git .antigen

source "$HOME/.antigen/antigen.zsh"

# plugins
antigen-use oh-my-zsh
antigen-bundle git
antigen-bundle svn
antigen-bundle gem
antigen-bundle npm
antigen-bundle bower
antigen-bundle command-not-found
antigen-bundle sublime
antigen-bundle vagrant
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-history-substring-search

# default theme
antigen theme Granze/G-zsh-theme-2 granze2

antigen-apply


# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


## Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias gti="git"
alias ains="sudo apt-get install"
alias aupd="sudo apt-get update"
alias aupg="sudo apt-get upgrade"
alias apur="sudo apt-get purge"
alias addrepo="sudo apt-add-repository && sudo apt-get update"

# functions
function subl(){ command subl "$@" & }
