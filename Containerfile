ARG FEDORA
ARG FROM
FROM quay.io/fedora-ostree-desktops/${FROM}:${FEDORA}
ARG FROM

# remove basic unneeded packages and install preferred utilities
RUN	rpm-ostree override remove \
		virtualbox-guest-additions \
		firefox firefox-langpacks \
		nano nano-default-editor \
		gnome-software gnome-software-rpm-ostree yelp \
		default-fonts-core-emoji google-noto-color-emoji-fonts google-noto-emoji-fonts \
		--install vim-default-editor \
	&& \
	rpm-ostree install \
		tailscale \
		NetworkManager-tui \
		gvfs-nfs \
		syncthing \
		distrobox \
		gnome-tweaks \
	&& \
	ostree container commit

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
