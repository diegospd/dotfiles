#!/bin/bash

rm -r ~/.xmonad
mkdir -p ~/.xmonad/lib
ln -s ~/.dotfiles/xmonad/xmonad.hs ~/.xmonad/xmonad.hs
ln -s ~/.dotfiles/xmonad/conky ~/.xmonad/conky
ln -s ~/.dotfiles/xmonad/dzen2 ~/.xmonad/dzen2
ln -s ~/.dotfiles/xmonad/InfoBars.hs ~/.xmonad/lib/InfoBars.hs
ln -s ~/.dotfiles/xmonad/Keys.hs ~/.xmonad/lib/Keys.hs
ln -s ~/.dotfiles/xmonad/Bash.hs ~/.xmonad/lib/Bash.hs

stack --system-ghc exec xmonad -- --recompile

ln -s ~/.xmonad/xmonad-x86_64-linux ~/.local/bin/xmonad-x86_64-linux
