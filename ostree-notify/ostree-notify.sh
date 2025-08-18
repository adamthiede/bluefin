#!/bin/bash
rpm-ostree status --pending-exit-77
ec=$?
if [[ $ec == 77 ]];then
	notify-send "System Updates" "Updates have been applied. Please reboot at your earliest convenience."
fi
