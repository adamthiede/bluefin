#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

rpm-ostree install rpmfusion-free-release-tainted

rpm-ostree override remove \
    libavcodec-free \
    libavfilter-free \
    libavformat-free \
    libavutil-free \
    libpostproc-free \
    libswresample-free \
    libswscale-free \
    --install ffmpeg

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
  libdvdcss \
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
