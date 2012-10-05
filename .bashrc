# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Colors
None=$'\e[0m'       # Reset

# Regular Colors
Black=$'\e[0;30m'        # Black
Red=$'\e[0;31m'          # Red
Green=$'\e[0;32m'        # Green
Yellow=$'\e[0;33m'       # Yellow
Blue=$'\e[0;34m'         # Blue
Purple=$'\e[0;35m'       # Purple
Cyan=$'\e[0;36m'         # Cyan
White=$'\e[0;37m'        # White

# Bold
BBlack=$'\e[1;30m'       # Black
BRed=$'\e[1;31m'         # Red
BGreen=$'\e[1;32m'       # Green
BYellow=$'\e[1;33m'      # Yellow
BBlue=$'\e[1;34m'        # Blue
BPurple=$'\e[1;35m'      # Purple
BCyan=$'\e[1;36m'        # Cyan
BWhite=$'\e[1;37m'       # White
BNone=$'\e[1;00m'        # Bold None

# Underline
UBlack=$'\e[4;30m'       # Black
URed=$'\e[4;31m'         # Red
UGreen=$'\e[4;32m'       # Green
UYellow=$'\e[4;33m'      # Yellow
UBlue=$'\e[4;34m'        # Blue
UPurple=$'\e[4;35m'      # Purple
UCyan=$'\e[4;36m'        # Cyan
UWhite=$'\e[4;37m'       # White
UNone=$'\e[4;37m'        # Underline None

# Underline High Intensity
UIBlack=$'\e[4;90m'       # Black
UIRed=$'\e[4;91m'         # Red
UIGreen=$'\e[4;92m'       # Green
UIYellow=$'\e[4;93m'      # Yellow
UIBlue=$'\e[4;94m'        # Blue
UIPurple=$'\e[4;95m'      # Purple
UICyan=$'\e[4;96m'        # Cyan
UIWhite=$'\e[4;97m'       # White

# Background
On_Black=$'\e[40m'       # Black
On_Red=$'\e[41m'         # Red
On_Green=$'\e[42m'       # Green
On_Yellow=$'\e[43m'      # Yellow
On_Blue=$'\e[44m'        # Blue
On_Purple=$'\e[45m'      # Purple
On_Cyan=$'\e[46m'        # Cyan
On_White=$'\e[47m'       # White

# High Intensity
IBlack=$'\e[0;90m'       # Black
IRed=$'\e[0;91m'         # Red
IGreen=$'\e[0;92m'       # Green
IYellow=$'\e[0;93m'      # Yellow
IBlue=$'\e[0;94m'        # Blue
IPurple=$'\e[0;95m'      # Purple
ICyan=$'\e[0;96m'        # Cyan
IWhite=$'\e[0;97m'       # White

# Bold High Intensity
BIBlack=$'\e[1;90m'      # Black
BIRed=$'\e[1;91m'        # Red
BIGreen=$'\e[1;92m'      # Green
BIYellow=$'\e[1;93m'     # Yellow
BIBlue=$'\e[1;94m'       # Blue
BIPurple=$'\e[1;95m'     # Purple
BICyan=$'\e[1;96m'       # Cyan
BIWhite=$'\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack=$'\e[0;100m'   # Black
On_IRed=$'\e[0;101m'     # Red
On_IGreen=$'\e[0;102m'   # Green
On_IYellow=$'\e[0;103m'  # Yellow
On_IBlue=$'\e[0;104m'    # Blue
On_IPurple=$'\e[10;95m'  # Purple
On_ICyan=$'\e[0;106m'    # Cyan
On_IWhite=$'\e[0;107m'   # White

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
#HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# synchronize history across all terminals -- **POTENTIALLY DANGEROUS!**
# use only in special situations, don't blame Nick if '!!' ends up being rm -rf *
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# write history out immediately
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# enable advanced history, found in ~/.bash_log
export PROMPT_COMMAND="_loghistory; $PROMPT_COMMAND"

# enable prompt error coloring
export PROMPT_COMMAND="export ecode=\$?; $PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


if [ "$color_prompt" = yes ]; then
    if [ $(id -u) -eq 0 ]; then
      PS1='${ICyan}$(__git_ps1)${None}${debian_chroot:+($debian_chroot)}${IRed}\u@${IGreen}\h${None}:${IBlue}\w$(if [ $ecode -eq 0 ]; then printf $None\$; else printf $Red\$$None; fi) '
    else
      PS1='${ICyan}$(__git_ps1)${None}${debian_chroot:+($debian_chroot)}${IGreen}\u@\h${None}:${IBlue}\w$(if [ $ecode -eq 0 ]; then printf $None\$; else printf $Red\$$None; fi) '
    fi
else
    PS1='$(__git_ps1)${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    tty=$(tty)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w (${tty:5})\a\]$PS1"
    ;;
*)
    ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# dump regular history log
alias h='history'

# dump enhanced history log
alias hh="cat $HOME/.bash_log"

# dump history of directories visited
alias histdirs="cat $HOME/.bash_log | awk -F ' ~~~ ' '{print \$2}' | uniq"

# add git branch

### User functions ###
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

psgrep() {
	if [ ! -z $1 ] ; then
		echo "Grepping for processes matching $1..."
		ps aux | grep $1 | grep -v grep
	else
		echo "!! Need name to grep for"
	fi
}

grab() {
	sudo chown -R ${USER} ${1:-.}
}


### Supporting functions ###

__git_ps1()
{
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf "[%s] " "${b##refs/heads/}";
    fi
}

_loghistory() {

# Detailed history log of shell activities, including time stamps, working directory etc.
#
# Based on 'hcmnt' by Dennis Williamson - 2009-06-05 - updated 2009-06-19
# (http://stackoverflow.com/questions/945288/saving-current-directory-to-bash-history)
#
# Add this function to your '~/.bashrc':
#
# Set the bash variable PROMPT_COMMAND to the name of this function and include
# these options:
#
#     e - add the output of an extra command contained in the histentrycmdextra variable
#     h - add the hostname
#     y - add the terminal device (tty)
#     n - don't add the directory
#     t - add the from and to directories for cd commands
#     l - path to the log file (default = $HOME/.bash_log)
#     ext or a variable
#
# See bottom of this function for examples.
#

    # make sure this is not changed elsewhere in '.bashrc';
    # if it is, you have to update the reg-ex's below
    export HISTTIMEFORMAT="[%F %T] ~~~ "

    local script=$FUNCNAME
    local histentrycmd=
    local cwd=
    local extra=
    local text=
    local logfile="$HOME/.bash_log"
    local hostname=
    local histentry=
    local histleader=
    local datetimestamp=
    local histlinenum=
    local options=":hyntel:"
    local option=
    OPTIND=1
    local usage="Usage: $script [-h] [-y] [-n|-t] [-e] [text] [-l logfile]"

    local ExtraOpt=
    local NoneOpt=
    local ToOpt=
    local tty=
    local ip=

    # *** process options to set flags ***

    while getopts $options option
    do
        case $option in
            h ) hostname=$HOSTNAME;;
            y ) tty=$(tty);;
            n ) if [[ $ToOpt ]]
                then
                    echo "$script: can't include both -n and -t."
                    echo $usage
                    return 1
                else
                    NoneOpt=1       # don't include path
                fi;;
            t ) if [[ $NoneOpt ]]
                then
                    echo "$script: can't include both -n and -t."
                    echo $usage
                    return 1
                else
                    ToOpt=1         # cd shows "from -> to"
                fi;;
            e ) ExtraOpt=1;;        # include histentrycmdextra
            l ) logfile=$OPTARG;;
            : ) echo "$script: missing filename: -$OPTARG."
                echo $usage
                return 1;;
            * ) echo "$script: invalid option: -$OPTARG."
                echo $usage
                return 1;;
        esac
    done

    text=($@)                       # arguments after the options are saved to add to the comment
    text="${text[*]:$OPTIND - 1:${#text[*]}}"

    # add the previous command(s) to the history file immediately
    # so that the history file is in sync across multiple shell sessions
    history -a

    # grab the most recent command from the command history
    histentry=$(history 1)

    # parse it out
    histleader=`expr "$histentry" : ' *\([0-9]*  \[[0-9]*-[0-9]*-[0-9]* [0-9]*:[0-9]*:[0-9]*\]\)'`
    histlinenum=`expr "$histleader" : ' *\([0-9]*  \)'`
    datetimestamp=`expr "$histleader" : '.*\(\[[0-9]*-[0-9]*-[0-9]* [0-9]*:[0-9]*:[0-9]*\]\)'`
    histentrycmd=${histentry#*~~~ }

    # protect against relogging previous command
    # if all that was actually entered by the user
    # was a (no-op) blank line
    if [[ -z $__PREV_HISTLINE || -z $__PREV_HISTCMD ]]
    then
        # new shell; initialize variables for next command
        export __PREV_HISTLINE=$histlinenum
        export __PREV_HISTCMD=$histentrycmd
        return
    elif [[ $histlinenum == $__PREV_HISTLINE  && $histentrycmd == $__PREV_HISTCMD ]]
    then
        # no new command was actually entered
        return
    else
        # new command entered; store for next comparison
        export __PREV_HISTLINE=$histlinenum
        export __PREV_HISTCMD=$histentrycmd
    fi

    if [[ -z $NoneOpt ]]            # are we adding the directory?
    then
        if [[ ${histentrycmd%% *} == "cd" || ${histentrycmd%% *} == "jd" ]]    # if it's a cd command, we want the old directory
        then                             #   so the comment matches other commands "where *were* you when this was done?"
            if [[ -z $OLDPWD ]]
            then
                OLDPWD="$HOME"
            fi
            if [[ $ToOpt ]]
            then
                cwd="$OLDPWD -> $PWD"    # show "from -> to" for cd
            else
                cwd=$OLDPWD              # just show "from"
            fi
        else
            cwd=$PWD                     # it's not a cd, so just show where we are
        fi
    fi

    if [[ $ExtraOpt && $histentrycmdextra ]]    # do we want a little something extra?
    then
        extra=$(eval "$histentrycmdextra")
    fi

    # strip off the old ### comment if there was one so they don't accumulate
    # then build the string (if text or extra aren't empty, add them with some decoration)
    histentrycmd="${datetimestamp} ${text:+[$text] }${tty:+[$tty] }${ip:+[$ip] }${extra:+[$extra] }~~~ ${hostname:+$hostname:}$cwd ~~~ ${histentrycmd# * ~~~ }"
    # save the entry in a logfile
    echo "$histentrycmd" >> $logfile || echo "$script: file error." ; return 1
}
