ARG FEDORA
FROM quay.io/fedora-ostree-desktops/xfce-atomic:${FEDORA}

# if chrome is specified, install it and remove firefox
ARG CHROME
RUN	bash -c "if [[ \"${CHROME}\" == \"chrome\" ]];then echo 'INSTALLING CHROME'; mkdir -p /usr/lib/opt/google /var/opt; ln -s /var/opt /opt; ln -s /usr/lib/opt/google /var/opt/google; sed -e 's,enabled=0,enabled=1,' -i /etc/yum.repos.d/google-chrome.repo; wget https://dl.google.com/linux/linux_signing_key.pub; rpm --import linux_signing_key.pub; rpm-ostree install google-chrome-stable; rpm-ostree override remove firefox firefox-langpacks; fi" && \
	rpm-ostree install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" && \
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
		mozilla-ublock-origin \
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

COPY configs/panel-default.xml /etc/xdg/xfce4/panel/default.xml
COPY configs/keyboardshortcuts-default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
COPY configs/xsettings-default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
COPY configs/xfce4-power-manager.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
COPY configs/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
COPY configs/link-opt.service /etc/systemd/system/link-opt.service

COPY ostree-notify/ostree-notify.sh /usr/bin/ostree-notify.sh
COPY ostree-notify/ostree-notify.timer /etc/systemd/user/ostree-notify.timer
COPY ostree-notify/ostree-notify.service /etc/systemd/user/ostree-notify.service

RUN mkdir -p /var/lib/alternatives && \
    curl -L https://github.com/ublue-os/config/raw/main/files/usr/etc/containers/policy.json -o /etc/containers/policy.json && \
    echo -e "[Daemon]\nAutomaticUpdatePolicy=stage\n" > /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable keyd.service && \
    systemctl enable link-opt.service && \
    systemctl disable NetworkManager-wait-online.service && \
    cp /usr/share/applications/redshift-gtk.desktop /etc/xdg/autostart/ && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    ln -s /etc/systemd/user/ostree-notify.timer /etc/systemd/user/default.target.wants/ && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
