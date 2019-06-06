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

# pacman -S --needed --noconfirm --overwrite reflector
# reflector --verbose -l 300 -p https --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syyu --needed --noconfirm --overwrite \
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
    vlc mplayer kaffeine \
    rhythmbox audacity \
    keepassxc \
    opera chromium firefox \
    texlive-most kile \
    virtualbox virtualbox-host-modules-arch \
    clojure intellij-idea-community-edition \
    ghc ghc-static \
    conky dzen2 rofi pacman-contrib espeak xorg-xrandr\
    unclutter \
    zsh ruby ruby-rdoc \
    steam ttf-liberation 

## enable daemons
systemctl enable \
    ntpd.service \
    sshd.service \
    systemd-modules-load.service

pkgfile --update

ntpd -qg
hwclock --systohc

echo "Now reboot, and manually enable sddm.service"
