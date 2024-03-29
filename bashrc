# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# color prompt

#count=0
#for color in "BLACK" "RED" "GREEN" "YELLOW" "BLUE" "PURPLE" "CYAN" "WHITE"
#do
#    eval ${color}=`echo -ne \"'\[\e[0;3'$count'm\]'\"`
#    eval B_${color}=`echo -ne \"'\[\e[1;3'$count'm\]'\"`
#    (( count = $count + 1 ))
#done

BLACK="\[\e[0;30m\]"
B_BLACK="\[\e[1;30m\]"
RED="\[\e[0;31m\]"
B_RED="\[\e[1;31m\]"
GREEN="\[\e[0;32m\]"
B_GREEN="\[\e[1;32m\]"
YELLOW="\[\e[0;33m\]"
B_YELLOW="\[\e[1;33m\]"
BLUE="\[\e[0;34m\]"
B_BLUE="\[\e[1;34m\]"
PURPLE="\[\e[0;35m\]"
B_PURPLE="\[\e[1;35m\]"
CYAN="\[\e[0;36m\]"
B_CYAN="\[\e[1;36m\]"
WHITE="\[\e[0;37m\]"
B_WHITE="\[\e[1;37m\]"

COLOR_RESET="\[\e[0m\]"

if [[ "`id -u`" -eq 0 ]]; then
    _PS1="$B_RED\u$COLOR_RESET@$B_GREEN\H$COLOR_RESET:$B_RED\w$COLOR_RESET\\$ "
else
    _PS1="$B_BLUE\u$COLOR_RESET@$B_GREEN\H$COLOR_RESET:$B_RED\w$COLOR_RESET\\$ "
fi

function update_PS1()
{
    nsh=$((SHLVL - 2))
    if [[ $nsh -gt 0 ]]; then
        nsh="($nsh)"
    else
        nsh=""
    fi
    virtual=""
    if [[ -n $VIRTUAL_ENV ]]; then
        virtual="(`basename \"$VIRTUAL_ENV\"`)"
    fi
    export PS1=$virtual$nsh$_PS1
}
PROMPT_COMMAND=update_PS1

# enable color support of ls and also add handy aliases
if [[ "$TERM" != "dumb" ]]; then
    if [[ `uname` == "Linux"  ]]; then
        eval "`dircolors -b`"
        alias ls='ls --color=auto'
    else
        alias ls='ls -G'
    fi
fi

# aliases
function _cd_work()
{
    for workdir in "$HOME/work"
    do
        if [[ -d "$workdir" ]]; then
            cd $workdir
            break
        fi
    done
}

alias ll='ls -lF -h'
alias la='ls -lFa -h'
alias l='ls -CF -h'

alias ..='cd ..'
alias cd..='cd ..'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if hash "ack-grep" > /dev/null 2>&1; then
    alias ack='ack-grep'
fi

alias du='du -sh'
alias df='df -h'

alias serve='python -m SimpleHTTPServer'

if hash "tmux" > /dev/null 2>&1; then
    alias tmux='TMPDIR=/tmp tmux -2'
fi

if [[ `uname` == "Darwin"  ]]; then
    alias syslog='tail -f /var/log/system.log'
else
    alias syslog='tail -f /var/log/syslog'
fi

if [[ `uname` == "Linux"  ]]; then
    alias screen-off='xset dpms force off'
fi

if [ -f /usr/local/bin/gdb ]; then
    alias gdb='/usr/local/bin/gdb'
fi

# Bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [[ `uname` == "Darwin"  ]]; then
    if hash "brew" > /dev/null 2>&1; then
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi
    fi
fi

# Home directory bin apps
export PATH=~/bin:$PATH

# local paths
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Always dump the core
ulimit -c unlimited

# ViM
alias vim='vim -p'
alias vi='vim'
alias gvim='gvim -p'
export EDITOR=vim

# Work
alias work=_cd_work
export DEBEMAIL="Tomas J. Sahagun <113.seattle@gmail.com>"

# language
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# Virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# Pythonbrew
[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

# rvm
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Bash completion for git
[[ -s $HOME/.git-completion.bash ]] && source $HOME/.git-completion.bash
