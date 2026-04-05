# ====================== FAST ZSH CONFIG ======================

# Colors + ls
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -G'

# Prompt: user@host ~/full/path/with/tilde (git branch)
autoload -Uz colors add-zsh-hook vcs_info
colors
add-zsh-hook precmd vcs_info


zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'

setopt prompt_subst

PS1='%F{green}%n@%m %F{blue}%~%f${vcs_info_msg_0_} %F{white}→ %f'

# History (huge + shared between terminals)
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

# Useful options
setopt AUTO_CD          # just type folder name to cd
setopt CORRECT          # spell correction
setopt INTERACTIVE_COMMENTS

# Completion (fast)
autoload -Uz compinit
compinit -C
export PATH="/opt/homebrew/opt/util-linux/bin:$PATH"
export PATH="/opt/homebrew/opt/util-linux/sbin:$PATH"
