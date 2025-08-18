ARG FEDORA=$(curl 'https://bodhi.fedoraproject.org/releases/?state=current'|jq -r '.releases[]|select(.name|startswith("F"))|.version'|sort -r|head -n1)
# get latest fedora version at all times
FROM quay.io/fedora-ostree-desktops/xfce-atomic:${FEDORA}

# install multimedia stuff; remove annoyances
RUN rpm-ostree install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" && \
	rpm-ostree install rpmfusion-free-release-tainted && \
	rpm-ostree install https://repos.fyralabs.com/terra$(rpm -E %fedora)/terra-release-0:$(rpm -E %fedora)-4.noarch.rpm && \
	rpm-ostree install \
		alsa-firmware \
		fuse \
		redshift-gtk \
		keyd \
		libreoffice-calc libreoffice-impress libreoffice-writer \
		gnome-themes-extra \
		google-noto-sans-cjk-fonts \
		elementary-xfce-icon-theme \
		intel-vaapi-driver \
		libdvdcss \
		pipewire-plugin-libcamera && \
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
		gparted \
		ModemManager NetworkManager-wwan NetworkManager-bluetooth \
		anaconda-core anaconda-gui anaconda-tui \
		initial-setup-gui-wayland-generic initial-setup initial-setup-gui \
		virtualbox-guest-additions \
		nano nano-default-editor \
		mint-x-icons \
		mint-y-icons \
		mint-y-theme \
		xfwm4-themes greybird-light-theme greybird-dark-theme greybird-xfce4-notifyd-theme greybird-xfwm4-theme \
		plocate \
		--install vim-default-editor \
		--install ffmpeg && \
	ostree container commit

RUN mkdir -p /var/lib/alternatives && \
    curl -L https://github.com/ublue-os/config/raw/main/files/usr/etc/containers/policy.json -o /etc/containers/policy.json && \
    echo -e "[Daemon]\nAutomaticUpdatePolicy=stage\n" > /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
