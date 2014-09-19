### Hisory ###

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=100000
setopt hist_ignore_space
setopt inc_append_history 
setopt share_history


### Options ###

setopt notify
zstyle :compinstall filename '~/.zshrc'

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD
setopt BASH_AUTO_LIST

# Now we can pipe to multiple outputs!
setopt MULTIOS

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# If we have a glob this will expand it
#setopt GLOB_COMPLETE
setopt PUSHD_MINUS

# use magic (this is default, but it can't hurt!)
setopt ZLE

setopt NO_HUP

setopt VI

setopt IGNORE_EOF

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER

# Case insensitive globbing
#setopt NO_CASE_GLOB

# Be Reasonable!
#setopt NUMERIC_GLOB_SORT

# I don't know why I never set this before.
#setopt EXTENDED_GLOB


### Modules ###
autoload -U compinit promptinit zcalc zsh-mime-setup colors
compinit
promptinit
zsh-mime-setup
colors
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

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line


### Correct mistyped command ###

# setopt correct
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "


### Parent shell name ###

# track names of programs running shell
if [[ -n "$CYGWIN" ]] ; then
	PNAME=$(basename "$(ps -p $PPID)")
else
	PNAME=$(ps -p $PPID -o comm=)
fi

if [[ "$PNAME" == "mc" ]] ; then
	TITLE="${TITLE}[mc]"
elif [[ "$PNAME" == "vim" ]] ; then
	TITLE="${TITLE}[vim]"
elif [[ "$PNAME" == "tmux" ]] || [[ -n "$TMUX" ]] ; then
	TITLE=""
elif [[ "$PNAME" == "screen" ]] || [[ -n "$STY" ]] ; then
	TITLE=""
fi
export TITLE


### Colors ###

# enable colors
eval "`dircolors -b`"

color_prompt=yes
if [ "$color_prompt" = yes ]; then

	# Command prompt colors
	ColorOff="%{$reset_color%}"
	UserNameColor="%{$fg_bold[green]%}"
	HostNameColor="%{$fg_bold[green]%}"
	PathColor="%{$fg_bold[magenta]%}"
	AppColor="%{$fg[cyan]%}"

	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		HostNameColor="%{$fg_bold[yellow]%}"
		UserNameColor="%{$fg_bold[yellow]%}"
	fi

	if [[ "$(id -u)" == "0" ]]; then
		UserNameColor="%{$fg_bold[red]%}"
	fi
else
	ColorOff=
	UserNameColor=
	HostNameColor=
	PathColor=
	AppColor=
fi

# command prompt
PS1="${AppColor}${TITLE}${ColorOff}${UserNameColor}%n${ColorOff}@${HostNameColor}%M${ColorOff}:${PathColor}%~${ColorOff} %#"

# colorful man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'			# end the info box
export LESS_TERMCAP_so=$'\E[0;43;30m'	# begin the info box
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

unset color_prompt

### Aliases definitions ###
alias q="exit"
alias loop="while [ 1 ] ; do "
alias mc="mc -x"

if [ -n "$CYGWIN" ]; then
	alias pwdc="pwd >! /dev/clipboard"
	alias pwdp=pwdc
	alias cdc="cd \`cat /dev/clipboard\`"
	alias cdp=cdc
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
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(echo $history[$HISTCMD] |sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi


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
zstyle ':completion:*:descriptions' format "%{${bg[blue]}%}[%d]%{${reset_color}%}"
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
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

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


# defaul text editor
export EDITOR=vim

# local .bashrc script (for local PATH's, etc)
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

export WWW_HOME='http://google.pl'

