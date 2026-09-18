#!/usr/bin/env bash

brightnessStr=$(brightnessctl -m | cut -d ',' -f4)
brightness="${brightnessStr%?}"

summary="Brightness $brightnessStr"
hints=('string:synchronous:brightness', "int:value:$brightness", 'int:transient:1')

read -ra hints <<< "${hints[@]/#/-h }"
notify-send "${hints[@]}" -r 100 "Brightness $brightnessStr"
