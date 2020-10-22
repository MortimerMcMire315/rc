#
# ~/.bashrc
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#--------------------------------------------------------------
#  Automatic setting of $DISPLAY (if not set already).
#  This works for me - your mileage may vary. . . .
#  The problem is that different types of terminals give
#+ different answers to 'who am i' (rxvt in particular can be
#+ troublesome) - however this code seems to work in a majority
#+ of cases.
#--------------------------------------------------------------

function get_xserver ()
{
    case $TERM in
        xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
            # Ane-Pieter Wieringa suggests the following alternative:
            #  I_AM=$(who am i)
            #  SERVER=${I_AM#*(}
            #  SERVER=${SERVER%*)}
            XSERVER=${XSERVER%%:*}
            ;;
            aterm | rxvt)
            # Find some code that works here. ...
            ;;
    esac
}

if [ -z "${DISPLAY:=\"\"}" ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) ||
       ${XSERVER} == "unix" ]]; then
          DISPLAY=":0.0"          # Display on local host.
    else
       DISPLAY=${XSERVER}:0.0     # Display on remote host.
    fi
fi

export DISPLAY

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

#set -o nounset     # These  two options are useful for debugging.
#set -o xtrace
alias debug="set -o nounset; set -o xtrace"
alias jtags="ctags -R app config lib && sed -i '' -E '/^(if|switch|function|module\.exports|it|describe).+language:js$/d' tags"
alias steamdir="cd ~/.steam/steam/steamapps/common"

ulimit -S -c 0      # Don't want coredumps.
set -o notify
set -o noclobber
set -o vi


# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.


# Normal Colors
#Black='\e[0;30m'        # Black
#Red='\e[0;31m'          # Red
#Green='\e[0;32m'        # Green
#Yellow='\e[0;33m'       # Yellow
#Blue='\e[0;34m'         # Blue
#Purple='\e[0;35m'       # Purple
#Cyan='\e[0;36m'         # Cyan
#White='\e[0;37m'        # White

# Bold
#BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
#BGreen='\e[1;32m'       # Green
#BYellow='\e[1;33m'      # Yellow
#BBlue='\e[1;34m'        # Blue
#BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
#BWhite='\e[1;37m'       # White

# Background
#On_Black='\e[40m'       # Black
#On_Red='\e[41m'         # Red
#On_Green='\e[42m'       # Green
#On_Yellow='\e[43m'      # Yellow
#On_Blue='\e[44m'        # Blue
#On_Purple='\e[45m'      # Purple
#On_Cyan='\e[46m'        # Cyan
#On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\
- DISPLAY on ${BRed}$DISPLAY${NC}\n"
date
if [ -x /usr/games/fortune ]; then
    /usr/games/fortune -s     # Makes our day a bit more fun.... :-)
fi

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
#export HISTTIMEFORMAT="$(echo -e "${BCyan}")[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts


#============================================================
#
#  ALIASES AND FUNCTIONS
#
#  Arguably, some functions defined here are quite big.
#  If you want to make this file smaller, these functions can
#+ be converted into scripts and removed from here.
#
#============================================================

#-------------------
# Personnal Aliases
#-------------------

# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias which='type -a'
alias ..='cd ..'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

#-------------------------------------------------------------
# A few fun ones
#-------------------------------------------------------------

# Adds some text in the terminal frame (if applicable).

function xtitle()
{
    case "$TERM" in
    *term* | rxvt)
        echo -en  "\e]0;$*\a" ;;
    *)  ;;
    esac
}


# Aliases that use xtitle
alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'

# .. and functions
#function man()
#{
#    for i ; do
#        xtitle The $(basename $1|tr -d .[:digit:]) manual
#        command man -a "$i"
#    done
#}


#-------------------------------------------------------------
# Make the following commands run in background automatically:
#-------------------------------------------------------------

function te()  # wrapper around xemacs/gnuserv
{
    if [ "$(gnuclient -batch -eval t 2>&-)" == "t" ]; then
       gnuclient -q "$@";
    else
       ( xemacs "$@" &);
    fi
}

function soffice() { command soffice "$@" & }
function firefox() { command firefox "$@" & }
function xpdf() { command xpdf "$@" & }


#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------


# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'"${1:-}"'*' \
-exec "${2:-file}" {} \;  ; }

function extract()      # Handy Extract Program
{
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"     ;;
            *.tar.gz)    tar xvzf "$1"     ;;
            *.bz2)       bunzip2 "$1"      ;;
            *.rar)       unrar x "$1"      ;;
            *.gz)        gunzip "$1"       ;;
            *.tar)       tar xvf "$1"      ;;
            *.tbz2)      tar xvjf "$1"     ;;
            *.tgz)       tar xvzf "$1"     ;;
            *.zip)       unzip "$1"        ;;
            *.Z)         uncompress "$1"   ;;
            *.7z)        7z x "$1"         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}


# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}

#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------


function my_ps() { ps "$@" -u "$USER" -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var="${1:-".*"}" ; }


function killps()   # kill by process name
{
    local pid pname sig="-TERM"   # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat="${!#}" )
    do
        pname=$(my_ps | awk '$1~var { print $5 }' var="$pid" )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill "$sig" "$pid"
        fi
    done
}

function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * info[1] / info[0] ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out="${info[2]} $out] (${free[0]} free on $fs)"
        echo -e "$out"
    done
}


function my_ip() # Get IP adress on ethernet.
{
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo "${MY_IP:-\"Not connected\"}"
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}$HOST"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Diskspace :$NC " ; mydf / "$HOME"
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}

# STACK FUNCTIONS

function sb()
{
    CABAL_FILE="*.cabal"
    FILES=( $CABAL_FILE )
    THE_FILE="${FILES[0]}"

    if [ -f "$THE_FILE" ]; then
        NAME=$(grep -E '^executable' < "$THE_FILE" | awk '{print $2}')
        if [ -n "$NAME" ]; then
            stack build && notify-send 'Compiler Finished' "$NAME has finished compiling."
        else
            echo "Could not find executable name."
        fi
    else
        echo "Cabal file not found. Consult yo' .bashrc."
    fi
}

function sbn()
{
    stack build && notify-send 'Compiler Finished' "Code has finished compiling."
}

function se()
{
    CABAL_FILE="*.cabal"
    FILES=( $CABAL_FILE )
    THE_FILE="${FILES[0]}"

    if [ -f "$THE_FILE" ]; then
        NAME=$(grep -E '^executable' < "$THE_FILE" | awk '{print $2}')
        if [ -n "$NAME" ]; then
            stack exec "$NAME" "$@"
        else
            echo "Could not find executable name."
        fi
    else
        echo "Cabal file not found. Consult yo' .bashrc."
    fi
}

function sbe()
{
    stack build && se "$@"
}

#=========================================================================
#
#  PROGRAMMABLE COMPLETION SECTION
#  Most are taken from the bash 2.05 documentation and from Ian McDonald's
# 'Bash completion' package (http://www.caliban.org/bash/#completion)
#  You will in fact need bash more recent then 3.0 for some features.
#
#  Note that most linux distributions now provide many completions
# 'out of the box' - however, you might need to make your own one day,
#  so I kept those here as examples.
#=========================================================================

alias ls='ls --color=auto'
alias dusort="du -a * | sort -n | sed -Ee 's/^[0-9]+./\"/' -e 's/$/\"/' | xargs du -ah"
alias pac='sudo pacman -S'
alias pacu='sudo pacman -Syu'
alias wine32='env WINEARCH=win32 WINEPREFIX="$HOME/.wine32" wine'
eval "$(dircolors ~/.dir_colors)"
export EDITOR='vim'
export GOPATH=~/.go
export PATH=$PATH:~/.cabal/bin:~/.go/bin:~/bin:~/.local/bin:~/.gem/ruby/2.4.0/bin:~/.config/composer/vendor/bin:~/scripts:/home/sayoder/.gem/ruby/2.7.0/bin

export PGDATA=/var/lib/postgres/data
export PGHOST=/tmp

set -o vi
shopt -s extglob

if [ "$(whoami)" = "root" ]; then
    PS1='\[\e[1;31m\]\u@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;31m\]\$\[\e[m\] \[\e[0;37m\]'
else
    PS1='\[\e[1;35m\]\u\[\e[0m\]@\[\e[1;37m\]\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;34m\]\$\[\e[m\] \[\e[0;37m\]'
fi

PATH="/home/sayoder/perl5/bin${PATH:+:${PATH}}"; export PATH;

PERL5LIB="/home/sayoder/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/sayoder/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/sayoder/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/sayoder/perl5"; export PERL_MM_OPT;
export PYTHONPATH=$PYTHONPATH:/opt/pydbgp/python3lib
