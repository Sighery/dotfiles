#!/usr/bin/env bash
# set -x

launch_rofi() {
	local rofi_options=(-dmenu -i -lines 3 -p "Launch scrcpy")
	local launcher=(rofi "${rofi_options[@]}")
	local menu_options="Default\n"
	rofi_selection="$(printf "$menu_options" | "${launcher[@]}")"
}

rofi_selection=""
launch_rofi

if [[ -n "$rofi_selection" ]]; then
	if [[ "$rofi_selection" == "Default" ]]; then
		scrcpy --shortcut-mod=lalt --stay-awake --screen-off-timeout=300 --no-video --mouse=uhid
	fi
fi
