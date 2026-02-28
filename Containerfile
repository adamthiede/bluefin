ARG FEDORA
ARG FROM
FROM quay.io/fedora-ostree-desktops/${FROM}:${FEDORA}

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
		mesa-va-drivers \
		virtualbox-guest-additions \
		nano nano-default-editor \
		--install vim-default-editor \
		--install mesa-va-drivers-freeworld \
		--install mesa-filesystem \
		--install ffmpeg && \
	rpm-ostree install \
		libdvdcss \
		libva-intel-driver \
		intel-media-driver \
		&& \
	ostree container commit

COPY ostree-notify/ostree-notify.sh /usr/bin/ostree-notify.sh
COPY ostree-notify/ostree-notify.timer /etc/systemd/user/ostree-notify.timer
COPY ostree-notify/ostree-notify.service /etc/systemd/user/ostree-notify.service

RUN mkdir -p /var/lib/alternatives && \
    curl -L https://github.com/ublue-os/config/raw/main/files/usr/etc/containers/policy.json -o /etc/containers/policy.json && \
    echo -e "[Daemon]\nAutomaticUpdatePolicy=stage\n" > /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl disable NetworkManager-wait-online.service && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    ln -s /etc/systemd/user/ostree-notify.timer /etc/systemd/user/default.target.wants/ && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
