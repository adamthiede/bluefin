#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# use override to replace mesa and others with less crippled versions

rpm-ostree override remove \
    libavcodec-free \
    libavfilter-free \
    libavformat-free \
    libavutil-free \
    libpostproc-free \
    libswresample-free \
    libswscale-free \
    --install ffmpeg

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# remove some base packages

rpm-ostree override remove \
	firefox firefox-langpacks \
	virtualbox-guest-additions \
	nano nano-default-editor \
 	plocate \
	yelp gnome-tour \
	--install vim-default-editor

# install preferred packages
rpm-ostree install \
  NetworkManager-tui \
  adw-gtk3-theme \
  aerc \
  alsa-firmware \
  android-tools \
  apr \
  apr-util \
  aria2 \
  btop \
  cargo \
  curl \
  curl \
  dino \
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
  gvfs-nfs \
  heif-pixbuf-loader \
  htop \
  imv \
  intel-vaapi-driver \
  isync \
  jq \
  just \
  keepassxc \
  kernel-tools \
  libcamera \
  libcamera-gstreamer \
  libcamera-ipa \
  libcamera-tools \
  libfdk-aac \
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
  pipewire-libs-extra \
  pipewire-plugin-libcamera \
  powerstat \
  river \
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
  tmux \
  traceroute \
  vim \
  vim \
  virt-manager \
  w3m \
  wireguard-tools \
  wl-clipboard \
  wl-clipboard \
  yt-dlp \
  yubikey-manager \
  zstd
