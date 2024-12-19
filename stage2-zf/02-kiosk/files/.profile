# ~/.profile: executed by the command interpreter for login shells.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

PS1='[\[\e[0;32m\]\u@\h \[\e[0;34m\]\W\[\e[0;00m\]]\$ ';

alias ll='ls -lhF'
alias la='ls -AF'
alias l='ls -CF'
alias s='sudo'
alias sus='sudo -s'

# first-run script
# [[ -f ./firstrun.sh ]] && ./firstrun.sh

# silent startx on video console

# setterm -powersave off -blank 0

# # If n has been pressed, don't start zf
# read -t 1 -n 1 key
#     if [[ $key = n ]]
# then
#     echo "Skip autoboot."
# else
#     if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#         echo "logged in via SSH"
#     else
#         # logged in locally (not via SSH)

#         # hide the prompt:
#         PS1=""
#         # set the terminal text color to black
#         setterm --foreground black --background black --cursor off --clear all
#         # start up zf as a background process
#         if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#             startx > /dev/null 2>&1
#             exit
#         fi
#     fi
# fi


