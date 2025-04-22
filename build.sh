#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf install -y tmux
dnf5 install -y \
     dex-autostart sway waybar ulauncher dunst wlogout \
     xdg-desktop-portal-wlr network-manager-applet \
     pasystray swaylock brightnessctl \
     blueman rtl-sdr \
     glibc.i686 GConf2

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable szydell/system76
dnf5 -y install system76-driver
dnf5 -y install firmware-manager system76-power system76-dkms
dnf5 -y copr disable szydell/system76

# dnf5 -y copr enable pgdev/ghostty
# dnf5 -y install ghostty
# dnf5 -y copr disable pgdev/ghostty

# Replace this with above once correct zig version is merged
dnf5 -y copr enable alternateved/ghostty
dnf5 -y install ghostty
dnf5 -y copr disable alternateved/ghostty

#### Install system76 driver
system76-driver-cli --model galp2

#### Example for enabling a System Unit File

systemctl enable podman.socket

systemctl enable system76-firmware-daemon
systemctl mask power-profiles-daemon.service
systemctl enable com.system76.PowerDaemon.service system76-power-wake
systemctl enable dkms
