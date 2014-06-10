# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# merge session histories
shopt -s histappend

# corrects typos
shopt -s cdspell

# resize ouput to fit window
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# track names of programs running shell
PNAME=$(ps -p $PPID -o comm=)
if [ "$PNAME" == "mc" ] ; then
	TITLE="${TITLE}[mc]"
elif [ "$PNAME" == "vim" ] || [ -n "$VIM" ] ; then
	TITLE="${TITLE}[vim]"
elif [ "$PNAME" == "tmux" ] ; then
	TITLE=""
elif [ "$PNAME" == "screen" ] || [ -n "$STY" ] ; then
	TITLE=""
fi

export TITLE

# enable colors
eval "`dircolors -b`"

# colorful man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m' # end the info box
export LESS_TERMCAP_so=$'\E[01;42;30m' # begin the info box
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

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

	# ANSI-COLOR-CODES
	ColorOff="\[\033[0m\]"

	# Regular
	Black="\[\033[0;30m\]"
	Red="\[\033[0;31m\]"
	Green="\[\033[0;32m\]"
	Yellow="\[\033[0;33m\]"
	Blue="\[\033[0;34m\]"
	Purple="\[\033[0;35m\]"
	Cyan="\[\033[0;36m\]"
	White="\[\033[0;37m\]"

	# Bold
	BBlack="\[\033[1;30m\]"
	BRed="\[\033[1;31m\]"
	BGreen="\[\033[1;32m\]"
	BYellow="\[\033[1;33m\]"
	BBlue="\[\033[1;34m\]"
	BPurple="\[\033[1;35m\]"
	BCyan="\[\033[1;36m\]"
	BWhite="\[\033[1;37m\]"

	# Command prompt colors
	UserNameColor=$BGreen
	HostNameColor=$BGreen
	PathColor=$BPurple
	AppColor=$Cyan

	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		HostNameColor=$BYellow
		UserNameColor=$BYellow
	fi

	if [ "$(id -u)" == "0" ]; then
		UserNameColor=$BRed
	fi
fi

# command prompt
PS1="${AppColor}${TITLE}${ColorOff}${UserNameColor}\u${ColorOff}@${HostNameColor}\h${ColorOff}:${PathColor}\w${ColorOff} \$"

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
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

# alias definitions
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias q="exit"
alias loop="while [ 1 ] ; do "
alias xterm1="xtermcontrol --bg=#000000"
alias xterm2="xtermcontrol --bg=#002b36"
alias p2c="xsel -po | xsel -b"
alias c2p="xsel -bo | xsel -p"
alias mc="mc -x"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# defaul text editor
export EDITOR=vim

# local .bashrc script (for local PATH's, etc)
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

export WWW_HOME='http://google.pl'

