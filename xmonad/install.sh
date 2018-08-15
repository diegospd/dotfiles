#!/bin/bash
## Downloads required packages and sets xmonad as the window manager for plasma
sudo pacman -S --needed xmonad xmonad-contrib conky dzen2 rofi pacman-contrib espeak
mkdir -p ~/.config/plasma-workspace/env/
echo "KDEWM=/usr/bin/xmonad" > ~/.config/plasma-workspace/env/set_window_manager.sh
chmod +x ~/.config/plasma-workspace/env/set_window_manager.sh
