#!/bin/bash

echo  "replacing kwin -> xmonad as plasma's window manager.."
echo "   inverse of disable_xmonad"
mkdir -p ~/.config/plasma-workspace/env/
echo "KDEWM=$HOME/.local/bin/xmonad-x86_64-linux" > ~/.config/plasma-workspace/env/set_window_manager.sh
chmod +x ~/.config/plasma-workspace/env/set_window_manager.sh
