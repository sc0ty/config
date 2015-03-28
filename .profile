if [ -f "$HOME/.Xresources" ]; then
	xrdb -merge "$HOME/.Xresources"
fi
if [ -f "$HOME/.Xresources_local" ]; then
	xrdb -merge "$HOME/.Xresources_local"
fi

