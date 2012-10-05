# If not running interactively, don't do anything
[ -z "$PS1" ] && return

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
LIME_YELLOW=$(tput setaf 190)
YELLOW=$(tput setaf 3)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

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
      PS1='\[${BRIGHT}\]\[${CYAN}\]$(__git_ps1)\[${NORMAL}\]${debian_chroot:+($debian_chroot)}\[${BRIGHT}\]\[${RED}\]\u@\[${GREEN}\]\h\[${NORMAL}\]:\[${BRIGHT}\]\[${BLUE}\]\w\[$(if [ $ecode -eq 0 ]; then printf $NORMAL; else printf $RED; fi)\]\$\[${NORMAL}\] '
    else
      PS1='\[${BRIGHT}\]\[${CYAN}\]$(__git_ps1)\[${NORMAL}\]${debian_chroot:+($debian_chroot)}\[${BRIGHT}\]\[${GREEN}\]\u@\h\[${NORMAL}\]:\[${BRIGHT}\]\[${BLUE}\]\w\[$(if [ $ecode -eq 0 ]; then printf $NORMAL; else printf $RED; fi)\]\$\[${NORMAL}\] '
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

## Color Table
## .................................................................................................... ##
Normal () { printf '\e[m'"$*"; }                  ; Tblack () { printf '\e[0;30m'"$*"'\e[m'; }
TNormal () { printf '\e[m'"$*"; }                 ; Tred () { printf '\e[0;31m'"$*"'\e[m'; }
Bold () { printf '\e[1m'"$*"'\e[m'; }             ; Tgreen () { printf '\e[0;32m'"$*"'\e[m'; }
TBold () { printf '\e[1m'"$*"'\e[m'; }            ; Tbrown () { printf '\e[0;33m'"$*"'\e[m'; }
Underline () { printf '\e[4m'"$*"'\e[m'; }        ; Tyellow () { printf '\e[0;33m'"$*"'\e[m'; }
TUnderline () { printf '\e[4m'"$*"'\e[m'; }       ; Tblue () { printf '\e[0;34m'"$*"'\e[m'; }
Flash () { printf '\e[5m'"$*"'\e[m'; }            ; Tmagenta () { printf '\e[0;35m'"$*"'\e[m'; }
TFlash () { printf '\e[5m'"$*"'\e[m'; }           ; Tpurple () { printf '\e[0;35m'"$*"'\e[m'; }
Invert () { printf '\e[7m'"$*"'\e[m'; }           ; Taqua () { printf '\e[0;36m'"$*"'\e[m'; }
TInvert () { printf '\e[7m'"$*"'\e[m'; }          ; Tcyan () { printf '\e[0;36m'"$*"'\e[m'; }
Invisible () { printf '\e[8m'"$*"'\e[m'; }        ; Tgrey () { printf '\e[0;37m'"$*"'\e[m'; }
TInvisible () { printf '\e[8m'"$*"'\e[m'; }       ; Twhite () { printf '\e[0;37m'"$*"'\e[m'; }
## ............... Bold Color Text ................ ## ............ Underlined Color Text ............. ##
TblackB () { printf '\e[1;30m'"$*"'\e[m'; }       ; TblackU () { printf '\e[4;30m'"$*"'\e[m'; }
TgreyB () { printf '\e[1;30m'"$*"'\e[m'; }        ; TredU () { printf '\e[4;31m'"$*"'\e[m'; }
TredB () { printf '\e[1;31m'"$*"'\e[m'; }         ; TgreenU () { printf '\e[4;32m'"$*"'\e[m'; }
TgreenB () { printf '\e[1;32m'"$*"'\e[m'; }       ; TbrownU () { printf '\e[4;33m'"$*"'\e[m'; }
TbrownB () { printf '\e[1;33m'"$*"'\e[m'; }       ; TyellowU () { printf '\e[4;33m'"$*"'\e[m'; }
TyellowB () { printf '\e[1;33m'"$*"'\e[m'; }      ; TblueU () { printf '\e[4;34m'"$*"'\e[m'; }
TblueB () { printf '\e[1;34m'"$*"'\e[m'; }        ; TmagentaU () { printf '\e[4;35m'"$*"'\e[m'; }
TmagentaB () { printf '\e[1;35m'"$*"'\e[m'; }     ; TpurpleU () { printf '\e[4;35m'"$*"'\e[m'; }
TpurpleB () { printf '\e[1;35m'"$*"'\e[m'; }      ; TaquaU () { printf '\e[4;36m'"$*"'\e[m'; }
TaquaB () { printf '\e[1;36m'"$*"'\e[m'; }        ; TcyanU () { printf '\e[4;36m'"$*"'\e[m'; }
TcyanB () { printf '\e[1;36m'"$*"'\e[m'; }        ; TgreyU () { printf '\e[4;37m'"$*"'\e[m'; }
TwhiteB () { printf '\e[1;37m'"$*"'\e[m'; }       ; TwhiteU () { printf '\e[4;37m'"$*"'\e[m'; }
## ............. Flashing Color Text .............. ## ............. Inverted Color Text .............. ##
TblackF () { printf '\e[5;30m'"$*"'\e[m'; }       ; TblackI () { printf '\e[7;40m'"$*"'\e[m'; }
TredF () { printf '\e[5;31m'"$*"'\e[m'; }         ; TredI () { printf '\e[7;41m'"$*"'\e[m'; }
TgreenF () { printf '\e[5;32m'"$*"'\e[m'; }       ; TgreenI () { printf '\e[7;42m'"$*"'\e[m'; }
TbrownF () { printf '\e[5;33m'"$*"'\e[m'; }       ; TbrownI () { printf '\e[7;43m'"$*"'\e[m'; }
TyellowF () { printf '\e[5;33m'"$*"'\e[m'; }      ; TyellowI () { printf '\e[7;43m'"$*"'\e[m'; }
TblueF () { printf '\e[5;34m'"$*"'\e[m'; }        ; TblueI () { printf '\e[7;44m'"$*"'\e[m'; }
TmagentaF () { printf '\e[5;35m'"$*"'\e[m'; }     ; TmagentaI () { printf '\e[7;45m'"$*"'\e[m'; }
TpurpleF () { printf '\e[5;35m'"$*"'\e[m'; }      ; TpurpleI () { printf '\e[7;45m'"$*"'\e[m'; }
TaquaF () { printf '\e[5;36m'"$*"'\e[m'; }        ; TaquaI () { printf '\e[7;46m'"$*"'\e[m'; }
TcyanF () { printf '\e[5;36m'"$*"'\e[m'; }        ; TcyanI () { printf '\e[7;46m'"$*"'\e[m'; }
TgreyF () { printf '\e[5;37m'"$*"'\e[m'; }        ; TgreyI () { printf '\e[7;47m'"$*"'\e[m'; }
TwhiteF () { printf '\e[5;37m'"$*"'\e[m'; }       ; TwhiteI () { printf '\e[7;47m'"$*"'\e[m'; }
## ............. Invisible Color Text ............. ## ........ Plain Text on Color Background ........ ##
TblackV () { printf '\e[8;30m'"$*"'\e[m'; }       ; Bblack () { printf '\e[m'"$*"'\e[m'; }
TredV () { printf '\e[8;31m'"$*"'\e[m'; }         ; Bred () { printf '\e[0;41m'"$*"'\e[m'; }
TgreenV () { printf '\e[8;32m'"$*"'\e[m'; }       ; Bgreen () { printf '\e[0;42m'"$*"'\e[m'; }
TbrownV () { printf '\e[8;33m'"$*"'\e[m'; }       ; Bbrown () { printf '\e[0;43m'"$*"'\e[m'; }
TyellowV () { printf '\e[8;33m'"$*"'\e[m'; }      ; Byellow () { printf '\e[0;43m'"$*"'\e[m'; }
TblueV () { printf '\e[8;34m'"$*"'\e[m'; }        ; Bblue () { printf '\e[0;44m'"$*"'\e[m'; }
TmagentaV () { printf '\e[8;35m'"$*"'\e[m'; }     ; Bmagenta () { printf '\e[0;45m'"$*"'\e[m'; }
TpurpleV () { printf '\e[8;35m'"$*"'\e[m'; }      ; Bpurple () { printf '\e[0;45m'"$*"'\e[m'; }
TaquaV () { printf '\e[8;36m'"$*"'\e[m'; }        ; Baqua () { printf '\e[0;46m'"$*"'\e[m'; }
TcyanV () { printf '\e[8;36m'"$*"'\e[m'; }        ; Bcyan () { printf '\e[0;46m'"$*"'\e[m'; }
TgreyV () { printf '\e[8;37m'"$*"'\e[m'; }        ; Bgrey () { printf '\e[0;47m'"$*"'\e[m'; }
TwhiteV () { printf '\e[8;37m'"$*"'\e[m'; }       ; Bwhite () { printf '\e[0;47m'"$*"'\e[m'; }
## ......... Bold Text on Color Background ........ ## ...... Underlined Text on Color Background ..... ##
BblackB () { printf '\e[1;40m'"$*"'\e[m'; }       ; BblackU () { printf '\e[4;40m'"$*"'\e[m'; }
BredB () { printf '\e[1;41m'"$*"'\e[m'; }         ; BredU () { printf '\e[4;41m'"$*"'\e[m'; }
BgreenB () { printf '\e[1;42m'"$*"'\e[m'; }       ; BgreenU () { printf '\e[4;42m'"$*"'\e[m'; }
BbrownB () { printf '\e[1;43m'"$*"'\e[m'; }       ; BbrownU () { printf '\e[4;43m'"$*"'\e[m'; }
ByellowB () { printf '\e[1;43m'"$*"'\e[m'; }      ; ByellowU () { printf '\e[4;43m'"$*"'\e[m'; }
BblueB () { printf '\e[1;44m'"$*"'\e[m'; }        ; BblueU () { printf '\e[4;44m'"$*"'\e[m'; }
BmagentaB () { printf '\e[1;45m'"$*"'\e[m'; }     ; BmagentaU () { printf '\e[4;45m'"$*"'\e[m'; }
BpurpleB () { printf '\e[1;45m'"$*"'\e[m'; }      ; BpurpleU () { printf '\e[4;45m'"$*"'\e[m'; }
BaquaB () { printf '\e[1;46m'"$*"'\e[m'; }        ; BaquaU () { printf '\e[4;46m'"$*"'\e[m'; }
BcyanB () { printf '\e[1;46m'"$*"'\e[m'; }        ; BcyanU () { printf '\e[4;46m'"$*"'\e[m'; }
BgreyB () { printf '\e[1;47m'"$*"'\e[m'; }        ; BgreyU () { printf '\e[4;47m'"$*"'\e[m'; }
BwhiteB () { printf '\e[1;47m'"$*"'\e[m'; }       ; BwhiteU () { printf '\e[4;47m'"$*"'\e[m'; }
## ....... Flashing Text on Color Background ...... ## ....... Inverted Text on Color Background ...... ##
BblackF () { printf '\e[5;40m'"$*"'\e[m'; }       ; BblackI () { printf '\e[7;30m'"$*"'\e[m'; }
BredF () { printf '\e[5;41m'"$*"'\e[m'; }         ; BredI () { printf '\e[7;31m'"$*"'\e[m'; }
BgreenF () { printf '\e[5;42m'"$*"'\e[m'; }       ; BgreenI () { printf '\e[7;32m'"$*"'\e[m'; }
BbrownF () { printf '\e[5;43m'"$*"'\e[m'; }       ; BbrownI () { printf '\e[7;33m'"$*"'\e[m'; }
ByellowF () { printf '\e[5;43m'"$*"'\e[m'; }      ; ByellowI () { printf '\e[7;33m'"$*"'\e[m'; }
BblueF () { printf '\e[5;44m'"$*"'\e[m'; }        ; BblueI () { printf '\e[7;34m'"$*"'\e[m'; }
BmagentaF () { printf '\e[5;45m'"$*"'\e[m'; }     ; BmagentaI () { printf '\e[7;35m'"$*"'\e[m'; }
BpurpleF () { printf '\e[5;45m'"$*"'\e[m'; }      ; BpurpleI () { printf '\e[7;35m'"$*"'\e[m'; }
BaquaF () { printf '\e[5;46m'"$*"'\e[m'; }        ; BaquaI () { printf '\e[7;36m'"$*"'\e[m'; }
BcyanF () { printf '\e[5;46m'"$*"'\e[m'; }        ; BcyanI () { printf '\e[7;36m'"$*"'\e[m'; }
BgreyF () { printf '\e[5;47m'"$*"'\e[m'; }        ; BgreyI () { printf '\e[7;37m'"$*"'\e[m'; }
BwhiteF () { printf '\e[5;47m'"$*"'\e[m'; }       ; BwhiteI () { printf '\e[7;37m'"$*"'\e[m'; }
## ...... Invisible Text on Color Background ...... ## ............... Color Code Notes ............... ##
BblackV () { printf '\e[8;40m'"$*"'\e[m'; }
BredV () { printf '\e[8;41m'"$*"'\e[m'; }
BgreenV () { printf '\e[8;42m'"$*"'\e[m'; }
BbrownV () { printf '\e[8;43m'"$*"'\e[m'; }
ByellowV () { printf '\e[8;43m'"$*"'\e[m'; }
BblueV () { printf '\e[8;44m'"$*"'\e[m'; }
BmagentaV () { printf '\e[8;45m'"$*"'\e[m'; }
BpurpleV () { printf '\e[8;45m'"$*"'\e[m'; }
BaquaV () { printf '\e[8;46m'"$*"'\e[m'; }
BcyanV () { printf '\e[8;46m'"$*"'\e[m'; }
BgreyV () { printf '\e[8;47m'"$*"'\e[m'; }
BwhiteV () { printf '\e[8;47m'"$*"'\e[m'; }
## .................................................................................................... ##
