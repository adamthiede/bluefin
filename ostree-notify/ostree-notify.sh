#!/bin/bash
rpm-ostree status --pending-exit-77
ec=$?
if [[ $ec == 77 ]];then
	notify-send -A Close=Close "System Updates Notification" "Updates have been applied, and a reboot is required to use the updated system."
fi
