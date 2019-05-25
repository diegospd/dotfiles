#!/bin/bash

## Run as root.
## Idempotent

## git should already be installed

pacman -Syyu --needed --noconfirm --overwrite \
    sddm xorg-server \
    plasma-desktop kde-applications-meta phonon-qt5-vlc \
    flameshot \
    dolphin dolphin-plugins encfs nfs-utils fuse3 \
    filelight testdisk gparted smartmontools gsmartcontrol \
    tree hwinfo htop \
    openssh ntp \
    pkgfile \
    ktorrent subdownloader \
    vlc mplayer kaffeine \
    rhythmbox audacity \
    keepassxc\
    texlive-most kile \
    opera chromium firefox \
    virtualbox virtualbox-host-modules-arch \
    ghc ghc-static \
    conky dzen2 rofi pacman-contrib espeak xorg-xrandr\
    unclutter \
    zsh ruby ruby-rdoc \
    intellij-idea-community-edition clojure \
    steam ttf-liberation 



## enable daemons
systemctl enable \
    ntpd.service \
    sshd.service \
    sddm.service \
    systemd-modules-load.service \
    plexmediaserver.service


pkgfile --update

ntpd -qg
hwclock --systohc

echo "Please reboot and install zsh :)"