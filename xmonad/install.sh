#!/bin/bash

echo "linking ~/.xmonad -> ~./dotfiles/xmonad/my-xmonad"
rm -r ~/.xmonad
ln -s ~/.dotfiles/xmonad/my-xmonad ~/.xmonad


## intalls ghc??
# stack install
