#!/bin/bash

# https://wiki.archlinux.org/index.php/dropbox#Prevent_automatic_updates
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist
sudo systemctl enable dropbox@$USER
