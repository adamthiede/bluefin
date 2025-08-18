ARG FEDORA="42"
FROM quay.io/fedora-ostree-desktops/xfce-atomic:${FEDORA}

# install multimedia stuff for intel
RUN rpm-ostree install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" && \
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
	    --install ffmpeg && \
	ostree container commit

# remove some annoyances
RUN rpm-ostree override remove \
	firefox firefox-langpacks \
	virtualbox-guest-additions \
	nano nano-default-editor \
	mint-x-icons \
	mint-y-icons \
	mint-y-theme \
	anaconda-core \
	podman \
 	plocate \
	--install vim-default-editor && \
    ostree container commit

# preferred packages
RUN rpm-ostree install \
  NetworkManager-tui \
  alsa-firmware \
  fuse \
  gnome-themes-extra \
  google-noto-sans-cjk-fonts \
  htop \
  intel-vaapi-driver \
  libdvdcss \
  pipewire-plugin-libcamera && \
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
