#antigen installation
# mkdir ~/.zsh-antigen; cd ~/.zsh-antigen; git clone https://github.com/zsh-users/antigen.git

source "$HOME/.antigen/antigen.zsh"

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
