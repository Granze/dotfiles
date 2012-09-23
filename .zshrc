#aliases
alias shs="python -m SimpleHTTPServer"
alias la="ls -al"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="granze"

#COMPLETION_WAITING_DOTS="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git gem zsh-syntax-highlighting extract history-substring-searchi node npm sublime)

source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
unsetopt correct_all