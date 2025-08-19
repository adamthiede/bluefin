#!/usr/bin/env bash
if [[ "$1" == "chrome" ]];then
    mkdir -p /usr/lib/opt/google /var/opt
    ln -s /usr/lib/opt/google /var/opt/google
    sed -e 's,enabled=0,enabled=1,' -i /etc/yum.repos.d/google-chrome.repo
    rpm-ostree override remove firefox firefox-langpacks --install google-chrome-stable
fi
