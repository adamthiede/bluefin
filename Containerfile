ARG FEDORA="41"
FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA}

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
 	plocate \
	yelp gnome-tour \
	--install vim-default-editor && \
    ostree container commit

# preferred packages
RUN rpm-ostree install \
  NetworkManager-tui \
  adw-gtk3-theme \
  aerc \
  alsa-firmware \
  android-tools \
  apr \
  apr-util \
  aria2 \
  bemenu \
  btop \
  cargo \
  curl \
  discount \
  distrobox \
  fastfetch \
  ffmpegthumbnailer \
  flashrom \
  flatpak-spawn \
  fuse \
  fzf \
  git \
  gnome-epub-thumbnailer \
  gnome-tweaks \
  go \
  google-noto-sans-balinese-fonts \
  google-noto-sans-cjk-fonts \
  google-noto-sans-javanese-fonts \
  google-noto-sans-sundanese-fonts \
  grub2-tools-extra \
  gvfs-nfs \
  heif-pixbuf-loader \
  htop \
  imv \
  intel-vaapi-driver \
  isync \
  j4-dmenu-desktop \
  jq \
  just \
  keepassxc \
  kernel-tools \
  libcamera \
  libcamera-gstreamer \
  libcamera-ipa \
  libcamera-tools \
  libdvdcss \
  libratbag-ratbagd \
  libva-utils \
  lshw \
  mosh \
  mousepad \
  mpc \
  mpv \
  ncdu \
  ncmpcpp \
  neovim \
  net-tools \
  nethack \
  newsboat \
  nmap \
  nvme-cli \
  nvtop \
  openrgb-udev-rules \
  openssl \
  pam-u2f \
  pam_yubico \
  pamu2fcfg \
  pipewire-plugin-libcamera \
  powerstat \
  river \
  sway \
  swaylock \
  swayidle \
  rsync \
  rust \
  seahorse \
  smartmontools \
  squashfs-tools \
  symlinks \
  syncthing \
  tailscale \
  tcpdump \
  tmux \
  traceroute \
  vim \
  virt-manager \
  w3m \
  waybar \
  wireguard-tools \
  wl-clipboard \
  yt-dlp \
  yubikey-manager \
  zstd && \
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
