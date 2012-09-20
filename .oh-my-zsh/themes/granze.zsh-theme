#granze theme v 1.0
PROMPT='%{$fg_bold[white]%}%n%{$fg_bold[yellow]%} ➜ %{$fg_no_bold[green]%}%c $(git_prompt_info)%{$reset_color%} » '
RPROMPT='%{$fg_bold[white]%}@ %m%{$reset_color%}'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$bg[green]%}%{$fg_no_bold[black]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$bg[black]%}%{$fg_bold[green]%} ✔"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$bg[black]%}%{$fg_bold[yellow]%} ✗"