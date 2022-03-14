# set vim mode in terminal
set -o vi

#
# Terminal colors
#
export PS1="\[$(tput setaf 2)\]hulk:\W $ \[\e[m\]"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

#
# Alias
#
vimc() {
  vim $(which $1)
}

# hide the ‘default interactive shell is now zsh’
export BASH_SILENCE_DEPRECATION_WARNING=1
