#!/usr/bin/env bash

status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo $status | cut -d ' ' -f2)
volume=$(echo "$volume * 100" | bc -l | sed 's/.00$//g')
is_muted=$(echo $status | cut -d ' ' -f3)

#echo $status
#echo $volume
#echo $is_muted

summary="Volume $volume%"
hints=('string:synchronous:volume', "int:value:$volume", 'int:transient:1')

if [ "$is_muted" == '[MUTED]' ]; then
	hints+=('string:hlcolor:#FFFF00')
	summary+=" $is_muted"
fi


read -ra hints <<< "${hints[@]/#/-h }"
notify-send "${hints[@]}" -r 100 "Volume $volume% $is_muted"
