#!/bin/bash
## sets xmonad as the window manager for plasma
mkdir -p ~/.config/plasma-workspace/env/
# echo "KDEWM=/usr/bin/stack --system-ghc exec xmonad" > ~/.config/plasma-workspace/env/set_window_manager.sh

echo "KDEWM=$HOME/.local/bin/xmonad" > ~/.config/plasma-workspace/env/set_window_manager.sh
# echo "KDEWM=~/.local/bin/xmonad" > ~/.config/plasma-workspace/env/set_window_manager.sh

chmod +x ~/.config/plasma-workspace/env/set_window_manager.sh
