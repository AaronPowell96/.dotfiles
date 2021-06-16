echo "bash rc called"
setgituser(){
    if [ "$1" = "main" ];then
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
    echo "No user found"
    fi
}

if [ -f ~/.bash_aliases ]; then
    \. ~/.bash_aliases
fi

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

PS1='\e[0;31m\@\e[m - \e[0;33m$(parse_git_username)\e[m \e[0;35m(\w)\e[m \e[0;32m$(__git_ps1 "(%s)")\e[m '