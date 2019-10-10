#!/usr/bin/env bash

OPERATION=$1
BASEDIR=$2

PACKAGES=`apm list --installed --packages --bare`
THEMES=`apm list --installed --themes --bare`

if [ -z "$BASEDIR" ]; then
	BASEDIR="./"
elif [ "${BASEDIR: -1}" != "/" ]; then
	BASEDIR+="/"
fi

PACKAGES_FILE="${BASEDIR}atom-packages.list"
THEMES_FILE="${BASEDIR}atom-themes.list"

if [ "$OPERATION" == "install" ]; then
	files=("$PACKAGES_FILE" "$THEMES_FILE")
	for file in "${files[@]}"; do
		# Last lines don't necessarily always include a newline
		grep . "${file}" | while read package; do
			package=`printf "$package" | cut -d"@" -f1`

			if [ ! -d "$HOME/.atom/packages/$package" ]; then
				apm install "$package"
			fi
		done
	done
else
	printf "$PACKAGES" > "$PACKAGES_FILE"
	printf "$THEMES" > "$THEMES_FILE"
fi
