#!/bin/bash
sname=$(
	dialog --colors \
		--title "" \
		--inputbox "\Z5Enter the session name:" 8 40 \
		3>&1 1>&2 2>&3 3>&-
) &&
	tmux attach -t $sname || tmux new -s $sname
