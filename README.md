# How-To:

0. Install Fedora Silverblue, Sericea, whatever.
1. First pin your original deployment:

```
sudo ostree admin pin 0
```

2. Rebase to the image:

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/adamthiede/bluefin:latest
```

3. Rebase to the image in a verified way??

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/adamthiede/bluefin:latest
```

That's it.

## What is this?

This is an opinionated, customized, Fedora Atomic XFCE. It is inspired by [nixbook](https://github.com/mkellyxp/nixbook). It's intended for low-spec machines like old chromebooks or celeron/pentium laptops.

Main changes:

- rpmfusion repos and drivers for Intel GPUs
- keyd, for potential chromebook key remaps (see [here](https://github.com/WeirdTreeThing/cros-keyboard-map))
- some unnecessary programs and packages removed
- libreoffice writer/calc/impress (word/powerpoint/excel)
- redshift for screen temperature adjustment
- pre-configured theme and desktop layout
- elementary xfce icons
- auto updates
- flatpak removed (flatpak applications take up a lot of space; the systems I'm targeting have 16, 32, or 64 GB of storage)


