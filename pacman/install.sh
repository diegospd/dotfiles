#!/bin/bash


sudo pacman -S --needed sddm \
                        filelight testdisk gparted \
                        git \
                        tree hwinfo htop \
                        openssh ntp \
                        pkgfile \
                        ktorrent subdownloader \
                        vlc mplayer kaffeine \
                        keepassx \
                        texlive-most kile \
                        opera chromium firefox \
                        virtualbox virtualbox-host-modules-arch \
                        ghc ghc-static \
                        conky dzen2 rofi pacman-contrib espeak \
                        zsh ruby
                        


## Build and install aurman
gpg --recv-key 465022E743D71E39 
git clone https://aur.archlinux.org/aurman.git
cd aurman
makepkg -si
cd ..
rm -rf aurman


aurman -S --needed --noconfirm sublime-text-dev \
                               dropbox dropbox-cli \
                               google-chrome \
                               spotify \
                               stack-bin \
                               ffmpeg-compat-54 \ # spotify local files
                               gitkraken 


## Haskell management
## Make sure ~/.local/bin is in your $PATH
stack setup --system-ghc
stack install --system-ghc cabal-install xmonad xmonad-contrib

sudo systemctl enable \
                  systemd-modules-load.service \
                  ntpd.service \
                  sshd.service

sudo pkgfile --update

echo "Please reboot :)"
