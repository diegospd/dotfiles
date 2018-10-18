#/bin/bash

sudo cp pacman.conf /etc/pacman.conf
sudo pacman -Rns antergos-mirrorlist antergos-keyring antergos-midnight-timers

sudo systemctl disable lightdm.service
sudo systemctl enable sddm.service
sudo pacman -Rns lightdm

sudo systemctl start sshd.service
sudo systemctl enable ssdh.service
