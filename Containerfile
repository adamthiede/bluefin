ARG FEDORA
ARG FROM
FROM quay.io/fedora-ostree-desktops/${FROM}:${FEDORA}
ARG FROM

RUN	rpm-ostree install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" && \
	rpm-ostree install "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" && \
	rpm-ostree install rpmfusion-free-release-tainted && \
	rpm-ostree override remove \
		ffmpeg-free \
		libavcodec-free \
		libavdevice-free \
		libavfilter-free \
		libavformat-free \
		libavutil-free \
		libpostproc-free \
		libswresample-free \
		libswscale-free \
		virtualbox-guest-additions \
		firefox \
		firefox-langpacks \
		nano nano-default-editor \
		--install vim-default-editor \
		--install ffmpeg && \
	rpm-ostree install \
		libdvdcss \
		libva-intel-driver \
		intel-media-driver \
		tailscale \
		NetworkManager-tui \
		gvfs-nfs \
		syncthing \
		gnome-themes-extra \
		&& \
	ostree container commit

# specific silverblue removals and additions
RUN bash -c "if [[ $FROM == 'silverblue' ]];then rpm-ostree override remove bolt gnome-software gnome-software-rpm-ostree && rpm-ostree install gnome-shell-extension-caffeine gnome-shell-extension-appindicator gnome-tweaks gnome-extensions-app && ostree container commit; fi"
# specific kinoite removals and additions
RUN bash -c "if [[ $FROM == 'kinoite' ]];then echo 'nothing for now'; fi"

COPY ostree-notify/ostree-notify.sh /usr/bin/ostree-notify.sh
COPY ostree-notify/ostree-notify.timer /etc/systemd/user/ostree-notify.timer
COPY ostree-notify/ostree-notify.service /etc/systemd/user/ostree-notify.service
COPY update-flatpak/update-flatpak.timer /etc/systemd/system/update-flatpak.timer
COPY update-flatpak/update-flatpak.service /etc/systemd/system/update-flatpak.service

RUN mkdir -p /var/lib/alternatives && \
    curl -L https://github.com/ublue-os/config/raw/main/files/usr/etc/containers/policy.json -o /etc/containers/policy.json && \
    echo -e "[Daemon]\nAutomaticUpdatePolicy=stage\n" > /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    ln -s /etc/systemd/user/ostree-notify.timer /etc/systemd/user/default.target.wants/ && \
	systemctl enable update-flatpak.timer && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
