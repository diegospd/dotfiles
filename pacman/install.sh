#!/bin/bash

sudo pacman -S --needed filelight testdisk gparted\
                        git \
                        tree hwinfo\
                        pkgfile \
                        ktorrent \
                        keepassx \
                        texlive-most kile \
                        opera chromium firefox \
                        ghc cabal-install stack alex happy hlint\

sudo pkgfile --update



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
                               gitkraken
