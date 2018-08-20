#/bin/bash

sudo reflector --verbose -l 300 -p https --sort rate --save /etc/pacman.d/mirrorlist 
sudo pacman -Syy
