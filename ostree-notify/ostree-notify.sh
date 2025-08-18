#!/bin/bash
rpm-ostree status --pending-exit-77
ec=$?
if [[ $ec == 77 ]];then
	# 60 second persistent notification
	notify-send -t 60000 "System Updates Notification" "Updates have been applied, and a reboot is required to use the updated system."
fi
