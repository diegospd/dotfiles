#!/bin/bash
## sets xmonad as the window manager for plasma
mkdir -p ~/.config/plasma-workspace/env/
echo "KDEWM=$HOME/.local/bin/my-xmonad" > ~/.config/plasma-workspace/env/set_window_manager.sh
chmod +x ~/.config/plasma-workspace/env/set_window_manager.sh
