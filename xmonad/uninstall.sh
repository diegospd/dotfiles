#!/bin/bash
## Stop using xmonad as Plasma's window manager
## All pacman packages remain installed
[ -e ~/.config/plasma-workspace/env/set_window_manager.sh ] \
    && rm ~/.config/plasma-workspace/env/set_window_manager.sh
