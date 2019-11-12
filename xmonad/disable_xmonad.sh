#!/bin/bash

echo "Stoped using xmonad as Plasma's window manager"
echo "   reverting to kwin [?]"
echo "   all pacman packages remain installed"
echo "   inverse of enable_xmonad"
[ -e ~/.config/plasma-workspace/env/set_window_manager.sh ] \
    && rm ~/.config/plasma-workspace/env/set_window_manager.sh
