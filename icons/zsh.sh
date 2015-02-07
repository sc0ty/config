if [[ -z "$ICON_PATH" ]]; then
	export ICON_PATH="$HOME/.config/config/icons"
fi

function set_icon() {
	export ICON=$1
	xseticon -id $WINDOWID $1
}
function set_icon_command() {
	if [[ $1 == fg ]]; then
        local cmd=${jobtexts[%+]}
    elif [[ $1 == fg\ * ]]; then
        local cmd=${jobtexts[${1#fg }]}
    else
		local cmd="${1/%\ */}"
	fi

	if [[ -n "$cmd" ]]; then
		local filename=${ICON_PATH}/commands/$(basename $cmd).png
		if [[ -e "$filename" ]]; then
			set_icon $filename
		elif [[ "$(id -u)" == "0" ]]; then
			set_icon $ICON_PATH/root-default.png
		else
			set_icon $ICON_PATH/default.png
		fi
	fi
}
function set_icon_term() {
	if [[ "$(id -u)" == "0" ]]; then
		set_icon $ICON_PATH/root-terminal.png
	else
		set_icon $ICON_PATH/terminal.png
	fi
}
function set_icon_prev() {
	set_icon_command $PNAME
}

if [[ -n "$WINDOWID" ]]; then
	which xseticon > /dev/null
	if [[ $? == 0 ]]; then
		precmd_functions=($precmd_functions set_icon_term)
		preexec_functions=($preexec_functions set_icon_command)
		zshexit_functions=($preexec_functions set_icon_prev)
	fi
fi

