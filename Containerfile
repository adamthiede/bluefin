## 1. BUILD ARGS
# These allow changing the produced image by passing different build args to adjust
# the source from which your image is built.
# Build args can be provided on the commandline when building locally with:
#   podman build -f Containerfile --build-arg FEDORA_VERSION=40 -t local-image

# SOURCE_IMAGE arg can be anything from ublue upstream which matches your desired version:
# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
# - "silverblue"
# - "kinoite"
# - "sericea"
# - "onyx"
# - "lazurite"
# - "vauxite"
# - "base"
#
#  "aurora", "bazzite", "bluefin" or "ucore" may also be used but have different suffixes.
ARG SOURCE_IMAGE="silverblue"
#ARG SOURCE_IMAGE="bluefin"

## SOURCE_SUFFIX arg should include a hyphen and the appropriate suffix name
# These examples all work for silverblue/kinoite/sericea/onyx/lazurite/vauxite/base
# - "-main"
# - "-nvidia"
# - "-asus"
# - "-asus-nvidia"
# - "-surface"
# - "-surface-nvidia"
ARG SOURCE_SUFFIX="-main"
#
# aurora, bazzite and bluefin each have unique suffixes. Please check the specific image.
# ucore has the following possible suffixes
# - stable
# - stable-nvidia
# - stable-zfs
# - stable-nvidia-zfs
# - (and the above with testing rather than stable)
#ARG SOURCE_SUFFIX="-stable"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="latest"

ARG FEDORA="41"


### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
#FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}
#FROM ghcr.io/adamthiede/silverblue-main:latest
FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA}

### 3. MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

COPY build.sh /tmp/build.sh

# install multimedia stuff for intel
RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm && \
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
  wireguard-tools \
  wl-clipboard \
  yt-dlp \
  yubikey-manager \
  zstd && \
  ostree container commit

RUN mkdir -p /var/lib/alternatives && \
    curl -L https://github.com/ublue-os/config/raw/main/files/usr/etc/containers/policy.json -o /etc/containers/policy.json && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
