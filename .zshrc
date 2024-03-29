### Hisory ###

HISTFILE=~/.histfile
HISTSIZE=1000				# lines to read on startup
SAVEHIST=100000				# lines to store in HISTFILE
setopt hist_ignore_space	# do not store commands started with space
setopt inc_append_history	# append HISTFILE after every instruction
setopt share_history		# share history between zsh sessions


### Options ###

setopt notify				# report status of the background jobs immediately
zstyle :compinstall filename '~/.zshrc'
setopt AUTO_CD				# cd without cd
setopt BASH_AUTO_LIST		# auto list choices on double tab for ambigous completion
setopt MULTIOS				# multiple pipelines
setopt AUTO_NAME_DIRS		# auto expand dir names
#setopt GLOB_COMPLETE		# expand globs
setopt PUSHD_MINUS

# use magic (this is default, but it can't hurt!)
setopt ZLE
setopt NO_HUP
setopt VI
#setopt IGNORE_EOF			# do not exit on ^D
setopt NO_FLOW_CONTROL		# disable ^S
setopt NO_CLOBBER			# do not overwrite files when redirected with stream redirection
#setopt NO_CASE_GLOB		# case insensitive globbing
#setopt NUMERIC_GLOB_SORT	# sort filenames numerically
#setopt EXTENDED_GLOB
setopt AUTO_PUSHD


### Modules ###
autoload -U compinit promptinit zcalc zsh-mime-setup select-word-style
compinit
promptinit
zsh-mime-setup
select-word-style bash	# ^W words delimiter will be slashes, dots etc, not only whitespaces
zmodload zsh/parameter
zmodload zsh/complist


### Key bindings ###

# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init() {
		echoti smkx
	}
	function zle-line-finish() {
		echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

bindkey -e                                            # Use emacs key bindings

bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
if [[ "${terminfo[kpp]}" != "" ]]; then
	bindkey "${terminfo[kpp]}" up-line-or-history       # [PageUp] - Up a line of history
fi
if [[ "${terminfo[knp]}" != "" ]]; then
	bindkey "${terminfo[knp]}" down-line-or-history     # [PageDown] - Down a line of history
fi

if [[ "${terminfo[kcuu1]}" != "" ]]; then
	bindkey "${terminfo[kcuu1]}" up-line-or-search      # start typing + [Up-Arrow] - fuzzy find history forward
fi
if [[ "${terminfo[kcud1]}" != "" ]]; then
	bindkey "${terminfo[kcud1]}" down-line-or-search    # start typing + [Down-Arrow] - fuzzy find history backward
fi

if [[ "${terminfo[khome]}" != "" ]]; then
	bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
	bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi

bindkey ' ' magic-space                               # [Space] - do history expansion

bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

if [[ "${terminfo[kcbt]}" != "" ]]; then
	bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
	bindkey "${terminfo[kdch1]}" delete-char            # [Delete] - delete forward
else
	bindkey "^[[3~" delete-char
	bindkey "^[3;5~" delete-char
	bindkey "\e[3~" delete-char
fi

# Ctrl+Delete deletes word
bindkey '^[[3;5~' kill-word

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# ^Z as alias for fg
fancy-ctrl-z () {
if [[ $#BUFFER -eq 0 ]]; then
	BUFFER="fg"
	zle accept-line
else
	zle push-input
	zle clear-screen
fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z


### Parent shell name ###

# track names of programs running shell
if [[ -n "$CYGWIN" ]] ; then
	PNAME=$(basename "$(ps -p $PPID)")
else
	PNAME=$(basename "$(ps -p $PPID -o comm=)")
fi

if [[ "$PNAME" == "mc" ]] ; then
	TITLE="${TITLE}[mc]"
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$REMOTEHOST" ]; then
	export REMOTE=1
fi


### Colors ###

colors_no=$(tput colors)
color_prompt=$force_color_prompt
if [ "$colors_no" -ge 8 ]; then
	color_prompt=yes
fi

if [ "$color_prompt" = yes ]; then

	# enable colors
	autoload -U colors
	colors
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		eval "`dircolors -b`"
	fi

	# colorful man pages
	export LESS_TERMCAP_mb=$'\E[01;31m'
	export LESS_TERMCAP_md=$'\E[01;31m'
	export LESS_TERMCAP_me=$'\E[0m'
	export LESS_TERMCAP_se=$'\E[0m'			# end the info box
	export LESS_TERMCAP_so=$'\E[0;43;30m'	# begin the info box
	export LESS_TERMCAP_ue=$'\E[0m'
	export LESS_TERMCAP_us=$'\E[01;32m'

	# Command prompt colors
	ColorOff="%{$reset_color%}"
	UserNameColor="%{$fg_bold[green]%}"
	HostNameColor="%{$fg_bold[green]%}"
	PathColor="%{$fg_bold[magenta]%}"
	TitleColor="%{$fg[cyan]%}"
	JobsColor="%{$fg_bold[red]%}"
	GitColor="%{$fg_bold[white]%}"
	GitUnstageColor="%{$fg[yellow]%}"
	GitStageColor="%{$fg[green]%}"
	CorrectFromColor="%{$fg_bold[red]%}"
	CorrectToColor="%{$fg_bold[green]%}"
	SelectGroupColor="%{$bg[blue]%}"

	if [ -n "$REMOTE" ]; then
		HostNameColor="%{$fg_bold[yellow]%}"
		UserNameColor="%{$fg_bold[yellow]%}"
	fi

	if [[ "$(id -u)" == "0" ]]; then
		UserNameColor="%{$fg_bold[red]%}"
	fi

	# Colored aliases
	if [[ "$OSTYPE" == "darwin"* ]]; then
		export CLICOLOR=1
	else
		alias ls='ls --color=auto'
	fi

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'

else
	unset zle_bracketed_paste
	ColorOff=
	UserNameColor=
	HostNameColor=
	PathColor=
	JobsColor=
	GitColor=
	GitUnstageColor=
	GitStageColor=
	CorrectFromColor=
	CorrectToColor=
	SelectGroupColor=
fi

# command prompt
PS1="${TitleColor}${TITLE}${JobsColor}%(1j.[%j].)${UserNameColor}%n${ColorOff}@${HostNameColor}%M${ColorOff}:${PathColor}%~${ColorOff} %#"

# rprompt - git branch info
if [[ "$PNAME" != "mc" ]] ; then
	setopt prompt_subst
	autoload -Uz vcs_info
	zstyle ':vcs_info:*' check-for-changes true
	zstyle ':vcs_info:*' unstagedstr   "${GitUnstageColor}[U]${ColorOff}"
	zstyle ':vcs_info:*' stagedstr     "${GitStageColor}[S]${ColorOff}"
	zstyle ':vcs_info:*' formats       "${GitColor}[%b]${ColorOff}%u%c%m"
	zstyle ':vcs_info:*' actionformats "${GitColor}[%a|%b]${ColorOff}%u%c"
	zstyle ':vcs_info:*' enable ALL
	precmd () { vcs_info }
	RPROMPT='${vcs_info_msg_0_}'
fi

### Correct mistyped command ###

setopt correct
export SPROMPT="Correct ${CorrectFromColor}%R${ColorOff} to ${CorrectToColor}%r${ColorOff}? (Yes, No, Abort, Edit) "

unset color_prompt color_prompt_force colors_no

### Aliases definitions ###
alias q="exit"
alias loop="while [ 1 ] ; do "
alias mc="mc -x"
alias l="ls -lh"
alias h="history 0 | grep --color"
alias psg="pgrep -a"
alias bell="printf '\a'"

if [ -n "$CYGWIN" ]; then
	alias pwdc="pwd >! /dev/clipboard"
	alias pwdp=pwdc
	alias cdc="cd \`cat /dev/clipboard\`"
	alias cdp=cdc
	alias alert='notify-send "$([ $? = 0 ] || echo error)" "$(echo $history[$HISTCMD] |sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
	if [ -n "$DISPLAY" ]; then
		alias p2c="xsel -po | xsel -b"
		alias c2p="xsel -bo | xsel -p"
		alias pwdc="echo -n \`pwd\` | xsel -b"
		alias pwdp="echo -n \`pwd\` | xsel -p"
		alias cdc="cd \`xsel -bo\`"
		alias cdp="cd \`xsel -po\`"
	else
		alias pwdc="pwd >! /tmp/clip"
		alias pwdp=pwdc
		alias cdc="cd \`cat /tmp/clip\`"
		alias cdp=cdc
	fi

	alias xterm1="xtermcontrol --bg=#000000"
	alias xterm2="xtermcontrol --bg=#002b36"
	alias alert='notify-send -i "$([ $? = 0 ] && echo terminal || echo error)" "$(echo $history[$HISTCMD] |sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')" || printf "\a"'
fi

function up() {
	if [ -z "$1" ]; then
		cd ..
	elif [ ! -z "${1##*[!0-9]*}" ]; then
		cd "$PWD$(printf '/..%.0s' {1..$1})"
	else
		local -a destdir
		local -a tmp
		destdir="${PWD%/$**}/"
		tmp="${PWD/$destdir/}"
		cd "$destdir${tmp%%/*}"
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

function predate() {
	while read line; do
		echo "$(date +%d-%T.%3N): $line"
	done
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


### Graphic file manager ###
set -A _NEXT_PATHS
set -A _DOWN_PATHS

cd_prev() {
	emulate -L zsh
	setopt nopushdminus
	builtin pushd -q +1 &>/dev/null || true
	zle reset-prompt
	set_title_pwd
}

cd_next() {
	emulate -L zsh
	setopt nopushdminus
	builtin pushd -q -0 &>/dev/null || true
	zle reset-prompt
	set_title_pwd
}

cd_up() {
	emulate -L zsh
	setopt nopushdminus
	builtin pushd -q .. &>/dev/null || true
	zle reset-prompt
	set_title_pwd
}

zle -N cd_prev
zle -N cd_next
zle -N cd_up
bindkey '^[[1;2A' cd_prev	# shift + up
bindkey '^[[1;2B' cd_next	# shift + down
bindkey '^[[1;2D' cd_up		# shift + left
bindkey '^[[1;2C' cd_prev	# shift + right

### Terminal title setup ###
function title() {
	case "$TERM" in
		xterm*|screen*|tmux*)	print -Pn "\e]0;$@\a" ;;
	esac
}
function set_title_command() {
	local -a cmd
	cmd=(${(z)1})

	case $cmd[1] in
		fg)	cmd="${(z)jobtexts[${(Q)cmd[2]:-%+}]}" ;;
		%*)	cmd="${(z)jobtexts[${(Q)cmd[1]:-%+}]}" ;;
	esac
	title $cmd
}
function set_title_pwd() {
	title " %~"
}
precmd_functions=($precmd_functions set_title_pwd)
preexec_functions=($preexec_functions set_title_command)


### Autocomplete ###

# press enter once to select and accept prompted command
bindkey -M menuselect '^M' .accept-line

#bindkey -M viins '\C-i' complete-word

setopt list_ambiguous
#setopt COMPLETE_IN_WORD
setopt AUTO_LIST

# Faster! (?)
zstyle ':completion::complete:*' use-cache 1

# case insensitive completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "${SelectGroupColor}[%d]${ColorOff}"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=39=34"

# Separate man page sections.  Neat.
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*' list-separator '--'

# complete with a menu for xwindow ids
zstyle ':completion:*:windows' menu on=0
zstyle ':completion:*:expand:*' tag-order all-expansions

# more errors allowed for large words and fewer for small words
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

# Errors format
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

# Don't complete stuff already on the line
zstyle ':completion::*:(rm|vi):*' ignore-line true

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion::approximate*:*' prefix-needed false

_force_rehash() {
	(( CURRENT == 1 )) && rehash
	return 1  # Because we didn't really complete anything
}

# Configure remembering recent directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection

export PATH="${PATH}:${HOME}/bin"

# defaul text editor
export EDITOR=vim

# local .bashrc script (for local PATH's, etc)
if [ -f ~/.bashrc_local ]; then
	. ~/.bashrc_local
fi

unset ColorOff UserNameColor HostNameColor PathColor JobsColor
unset GitColor GitUnstageColor GitStageColor
unset CorrectFromColor CorrectToColor SelectGroupColor

