#!/bin/bash

sudo pacman -S --needed filelight testdisk gparted\
                        git \
                        tree hwinfo\
                        pkgfile \
                        ktorrent \
                        keepassx \
                        opera chromium firefox \
                        ghc cabal-install stack alex happy \

sudo pkgfile --update


yaourt -S --needed --noconfirm sublime-text-dev \
                               dropbox dropbox-cli \
                               google-chrome \
                               spotify 
