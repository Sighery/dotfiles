#!/usr/bin/env bash
PROGRAMNAME=$0
OPERATION=$1
BASEDIR=$2

usage() {
	printf "usage: $PROGRAMNAME operation [basedir]\n"
	printf "\n"
	printf "operation can be either install or update.\n"
	printf "Install uses existing atom-packages.list and atom-themes.list \n"
	printf "files to install Atom packages automatically.\n"
	printf "Update updates those same files with locally installed Atom \n"
	printf "packages and themes.\n"
	printf "\n"
	printf "basedir is optional, defaulting to \"./\". It will be used to \n"
	printf "know where to fetch to install or update the atom-*.list files \n"
	printf "from.\n"
	exit 1
}

time_for_help() {
	if [ -z "$OPERATION" ]; then
		usage
	elif [ "$OPERATION" = "help" ] || [ "$OPERATION" = "h" ]; then
		usage
	elif [ "$OPERATION" = "--help" ] || [ "$OPERATION" = "-h" ]; then
		usage
	elif [ "$OPERATION" != "install" ] && [ "$OPERATION" != "update" ]; then
		usage
	fi

	return 1
}

time_for_help

# Apparently command substitution removes newlines
PACKAGES=`apm list --installed --packages --bare | xargs -n1 | cut -d"@" -f1`
printf -v PACKAGES "$PACKAGES\n"
THEMES=`apm list --installed --themes --bare | xargs -n1 | cut -d"@" -f1`
printf -v THEMES "$THEMES\n"

if [ -z "$BASEDIR" ]; then
	BASEDIR="./"
elif [ "${BASEDIR: -1}" != "/" ]; then
	BASEDIR+="/"
fi

PACKAGES_FILE="${BASEDIR}atom-packages.list"
THEMES_FILE="${BASEDIR}atom-themes.list"

if [ "$OPERATION" = "install" ]; then
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
elif [ "$OPERATION" = "update" ]; then
	printf "$PACKAGES" > "$PACKAGES_FILE"
	printf "$THEMES" > "$THEMES_FILE"
fi
