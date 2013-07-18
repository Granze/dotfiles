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

## Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias gti="git"
