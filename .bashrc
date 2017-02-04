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
if [ -n "$CYGWIN" ] ; then
	PNAME=$(basename "$(ps -p $PPID)")
else
	PNAME=$(ps -p $PPID -o comm=)
fi

if [ "$PNAME" == "mc" ] ; then
	TITLE="${TITLE}[mc]"
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$REMOTEHOST" ]; then
	export REMOTE=1
fi

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

color_prompt=yes
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
	TitleColor=$Cyan
	JobsColor=$BRed

	if [ -n "$REMOTE" ]; then
		HostNameColor=$BYellow
		UserNameColor=$BYellow
	fi

	if [ "$(id -u)" == "0" ]; then
		UserNameColor=$BRed
	fi
fi

# command prompt
PROMPT_COMMAND='hasjobs=$(jobs -p)'
PS1='${hasjobs:+[\j]}\$ '
PS1="${TitleColor}${TITLE}${JobsColor}"'${hasjobs:+[\j]}'"${UserNameColor}\u${ColorOff}@${HostNameColor}\h${ColorOff}:${PathColor}\w${ColorOff} \$"

# xterm title
case "$TERM" in
	xterm*|screen*|tmux*) PS1="\[\e]0;[bash] \w\a\]$PS1" ;;
esac

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# alias definitions
alias q="exit"
alias loop="while [ 1 ] ; do "
alias mc="mc -x"
alias l="ls -lh"
alias h="history | grep --color"
alias bell="printf '\a'"

if [ -n "$CYGWIN" ]; then
	alias pwdc="pwd > /dev/clipboard"
	alias pwdp=pwdc
	alias cdc="cd \`cat /dev/clipboard\`"
	alias cdp=cdc
	alias alert='notify-send "$([ $? = 0 ] || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
	if [ -n "$DISPLAY" ]; then
		alias p2c="xsel -po | xsel -b"
		alias c2p="xsel -bo | xsel -p"
		alias pwdc="echo -n \`pwd\` | xsel -b"
		alias pwdp="echo -n \`pwd\` | xsel -p"
		alias cdc="cd \`xsel -bo\`"
		alias cdp="cd \`xsel -po\`"
	else
		alias pwdc="pwd > /tmp/clip"
		alias pwdp=pwdc
		alias cdc="cd \`cat /tmp/clip\`"
		alias cdp=cdc
	fi

	alias xterm1="xtermcontrol --bg=#000000"
	alias xterm2="xtermcontrol --bg=#002b36"
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')" || printf "\a"'
fi

function up() {
	if [ "$PWD" != "/" ]; then
		if [ -z "$1" ]; then
			cd ..
		elif [ ! -z "${1##*[!0-9]*}" ]; then
			local -a tmp
			tmp=$(printf "%${1}s")
			cd "$PWD${tmp// /\/..}"
		else
			local -a destdir
			local -a tmp
			destdir="${PWD%/$**}/"
			tmp="${PWD/$destdir/}"
			cd "$destdir${tmp%%/*}"
		fi
	fi
}

function pingt() {
	while true; do
		ping -c1 $@ > /dev/null && break
		echo -n $?
		sleep 1
	done
	echo $?
}


### Tmux aliases ###

function tat() {
	if [ -z "$1" ]; then
		tmux list-sessions | grep -vq '(attached)'
		if [ "$?" -eq "0" ]; then
			tmux attach-session
		else
			tmux new-session
		fi
	else
		tmux new-session -As $@
	fi
}

alias tls="tmux list-sessions"


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

export PATH="${PATH}:${HOME}/bin"

# defaul text editor
export EDITOR=vim

# local .bashrc script (for local PATH's, etc)
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

command -v direnv 2>&1 > /dev/null && eval "$(direnv hook bash)"

export WWW_HOME='http://google.pl'

