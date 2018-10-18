#!/bin/bash

## Installs aurman and stack for the first time

gpg --recv-key 465022E743D71E39
git clone https://aur.archlinux.org/aurman.git
cd aurman
makepkg -si
cd ..
rm -rf aurman

aurman -S --needed --noconfirm stack-bin
stack --system-ghc setup 

echo " ~~ Install aurman and stack packages now."