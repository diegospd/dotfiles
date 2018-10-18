#!/bin/bash
## sets xmonad as the window manager for plasma
mkdir -p ~/.config/plasma-workspace/env/
echo "KDEWM=/usr/bin/xmonad" > ~/.config/plasma-workspace/env/set_window_manager.sh
chmod +x ~/.config/plasma-workspace/env/set_window_manager.sh
