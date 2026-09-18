#!/usr/bin/env sh

if [ -z "$1" ]; then
	echo "Provide a filepath" >&2
	exit 0
fi

in=$1

case "$in" in
	*.mov) ffmpeg -i "$in" -c copy -movflags +faststart "${in%.mov}.mp4" ;;
	*.webm) ffmpeg -i "$in" -c:v libx264 -c:a aac "${in%.webm}.mp4" ;;
	*) echo "Format not supported" >&2; exit 1 ;;
esac

exit 0
