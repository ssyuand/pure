#!/bin/bash
print_wifi() {
	ip=$(ip route get 8.8.8.8 2>/dev/null | grep -Eo 'src [0-9.]+' | grep -Eo '[0-9.]+')
	echo -e "[ $ip ]"
}

battery="BAT0"

has_battery() {
	if [ -d /sys/class/power_supply/$battery ]; then
		return 0
	fi
	return 1
}
get_battery_status() {
	charge="$(get_charge)"
	charge_st="$(get_charging_status)"
	Charging="⚡"
	no_Charging=""
	if [[ $charge_st == "Charging" ]]; then
		echo ""$charge"% "$Charging""
	else
		echo ""$no_Charging" "$charge"%"

	fi
}

get_charging_status() {
	cat "/sys/class/power_supply/$battery/status"
}

get_charge() {
	cat "/sys/class/power_supply/$battery/capacity"
}

get_status() {
	battery_status=""
	if $(has_battery); then
		battery_status=" $(get_battery_status)"
	fi

	echo "${battery_status}"
}

print_date() {
	date +" %a %d %b %Y |  %I:%M:%S %p %Z"
}
check_hhkb() {
	FILE=/dev/input/by-id/usb-Topre_Corporation_HHKB_Professional-event-kbd
	if [[ -L "$FILE" ]]; then
		prev=1
	else
		prev=0
	fi
	pmm $prev
}
pmm() {
	FILE=/dev/input/by-id/usb-Topre_Corporation_HHKB_Professional-event-kbd
	prev=$1
	sleep 2
	for run in {1..1000}; do
		if [[ -L "$FILE" ]]; then
			now=1
		else
			now=0
		fi
	done

	echo "$prev, $now"
	if [[ $prev == $now ]]; then
		return 3
	fi
	return $now
}

spid="$(pidof -o %PPID -x -- "statusbar.sh")"
echo $spid
xst=$(echo $DISPLAY)
if [[ $xst != "" && $spid == "" ]]; then
	# HHKB
	while true; do
		xsetroot -name "$(print_wifi) $(print_date) |$(get_status)"
		check_hhkb
		case $? in
		0) #  normal layout
			echo "out!"
			setxkbmap -layout us -option ctrl:swapcaps
			setxkbmap -option altwin:swap_lalt_lwin
			setxkbmap -option ctrl:swap_rctrl_lwin
			xset r rate 266 26
			;;
		1) # hhkb layout
			echo "in!"
			setxkbmap -layout us -option
			xset r rate 266 26
			;;
		3) # changed echo "3"
			echo "changed! nothing todo"
			;;
		esac
	done

fi
