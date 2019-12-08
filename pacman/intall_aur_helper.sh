#!/bin/bash

###  AUR support via yay
## https://github.com/Jguer/yay
git clone https://github.com/Jguer/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
