#!/usr/bin/env sh

if [ -n "$1" ]; then
	in="$1"

	case "$in" in
		*.png | *.jpg | *.jpeg) xclip -selection clipboard -t image/png -i "$1" ;;
		*) xclip -selection clipboard -i "$1" ;;
	esac
	exit 0
fi

if [ ! -t 0 ]; then
	xclip -selection clipboard -i
	exit 0
fi

echo "Provide a filepath or pipe data into stdin" >&2
exit 1
