echo "bash rc called"
set_git_user(){
    if [ "$1" = "aaron" ];then
    echo "Set Git User to Aaron"
    git config --global user.name "Aaron"
    git config --global user.email "Apowell829@gmail.com"
    exec bash
    elif [ "$1" = "amateur" ];then
    echo "Set Git User to Amateur Dev"
    git config --global user.name "The Amateur Dev"
    git config --global user.email "TheAmateurJSDev@gmail.com"
    exec bash
    else
    echo "No user found: 'aaron' or 'amateur'"
    fi
}

if [ -f ~/.bash_aliases ]; then
    \. ~/.bash_aliases
fi

### Set SSH Keys on startup
env=~/.ssh/agent.env
ssh-add ~/.ssh/*
agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

################
## Set Terminal Prompt
################
parse_git_user() {
    git config --get user.email
}
parse_git_username() {
    git config --get user.name
}
# parse_git_branch() {
#   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
# }
# check_is_git() {
#     GIT=git rev-parse --git-dir 2> /dev/null
#   if [ GIT != ".git" ];then
#   echo "BRANCH \e[0;32m($(parse_git_branch))\e[m | USER \e[0;34m($(parse_git_user))\e[m"
#   else
#   ""
#   fi
# }

## Variables don't seem to work with a dynamic promps, branches wont change when change dir, keeping just incase.
# BRANCH=$(check_is_git)
USER='\e[0;33m$(parse_git_user)\e[m'
TIME="\e[0;31m\@\e[m"
DIR="DIR \e[0;35m(\w)\e[m"
# Wrap colours in \[ .... \] otherwise terminal counts as chars and creates overlapping issue. 
PS1='\[\e[0;31m\]\@\[\e[m\] - \[\e[0;33m\]$(parse_git_username) \[\e[0;35m\](\w)\[\e[m\] \[\e[0;32m\]$(__git_ps1 "(%s)")\[\e[m\]'