#!/bin/bash

###  AUR support via yay
## https://aur.archlinux.org/packages/yay/
## https://github.com/Jguer/yay
git clone https://github.com/Jguer/yay.git
cp yay.PKGBUILD yay/PKGBUILD
cd yay
makepkg -si
cd ..
rm -rf yay
