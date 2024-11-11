#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

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
	gnome-software \
	--install vim-default-editor

# install preferred packages
rpm-ostree install mpv ffmpeg yt-dlp \
	sway sway-config-upstream foot j4-dmenu-desktop \
	bemenu fzf git curl htop neovim vim tmux go \
	xfce-polkit terminus-fonts wl-clipboard w3m aerc \
	android-tools aria2 btop cargo rust curl dino discount \
	doas fastfetch flashrom imv isync \
	jq kanshi keepassxc mosh mousepad mpc ncmpcpp \
	ncdu nethack newsboat nmap pmbootstrap rsync seahorse \
	gvfs-nfs fedora-flathub-remote \
	NetworkManager-tui syncthing tailscale

#### Example for enabling a System Unit File
#systemctl enable podman.socket
