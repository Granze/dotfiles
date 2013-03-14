## Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

## Set name of the theme to load.
ZSH_THEME="granze2"

## Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias tunnel="ssh  -i ~/.ssh/mmangione ubuntu@176.34.243.236 -L 3306:beintoords2.cbqogiqebrzc.eu-west-1.rds.amazonaws.com:3306"
alias gti="git"
alias g="git"

## Functions
# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

## Plugins
plugins=(git svn gem brew zsh-syntax-highlighting extract history-substring-search npm sublime)

source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh

## Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/git/bin:/usr/local/sbin
export "MAVEN_OPTS=-Xmx1024m -XX:MaxPermSize=1024m"
unsetopt correct_all