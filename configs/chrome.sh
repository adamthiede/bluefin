#!/usr/bin/env bash
set -e
set -x
echo "$1"
if [[ "$1" == "chrome" ]];then
    echo "--- INSTALLING CHROME"
    mkdir -p /usr/lib/opt/google /var/opt
    ln -s /var/opt  /opt
    ln -s /usr/lib/opt/google /var/opt/google
    sed -e 's,enabled=0,enabled=1,' -i /etc/yum.repos.d/google-chrome.repo
    sleep 5
    rpm-ostree override remove firefox firefox-langpacks
    sleep 5
    rpm-ostree install google-chrome-stable
    sleep 5
else
    echo "--- NOT INSTALLING CHROME"
fi
