#!/bin/bash
## git should already be installed
## Run as root.
## Idempotent

## https://stackoverflow.com/a/31872769
if [ "$(whoami)" != "root" ]
then
    source ~/.dotfiles/zsh/utils.sh
    echo "Updating arch"
    warning "Consider running mirrors"
    warning "Will ask for root password!"

    sudo su -s "$0"
    exit
fi


echo "Copy pacman.conf /etc/ first"
# pacman -S --needed --noconfirm --overwrite reflector
# reflector --verbose -l 300 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyu --needed --noconfirm --overwrite \
    base-devel \
    stack \
    yakuake \
    ghc ghc-static \
    netctl networkmanager net-tools \
    powerdevil \
    sddm xorg-server \
    plasma-desktop kde-applications-meta phonon-qt5-vlc \
    flameshot \
    dolphin dolphin-plugins encfs nfs-utils fuse3 \
    p7zip unrar gzip plan9port libarchive xz cabextract \
    filelight testdisk gparted smartmontools gsmartcontrol \
    tree hwinfo htop \
    openssh ntp \
    pkgfile \
    ktorrent subdownloader \
    vlc mplayer kaffeine alsa-utils \
    rhythmbox audacity \
    keepassxc \
    opera chromium firefox \
    conky dzen2 rofi pacman-contrib espeak xorg-xrandr \
    unclutter dunst \
    zsh ruby ruby-rdoc bash-completion \
    steam ttf-liberation lib32-gtk2 lib32-glib2 lib32-libxtst lib32-libxrandr lib32-gdk-pixbuf2 lib32-libva1 lib32-libvdpau  lib32-libpulse


## enable daemons
#systemctl enable \
#    ntpd.service \
#    sshd.service \
#    systemd-modules-load.service \
#    NetworkManager.service

#pkgfile --update

#ntpd -qg
#hwclock --systohc

echo "Consider inastalling:  nvidia nvidia-utils lib32-nvidia-utils lib32-opencl-nvidia"
echo "Manually install texlive-most kile"
echo "Now reboot, and manually enable sddm.service"
