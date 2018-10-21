#!/bin/bash

aurman -S --needed --noconfirm \
      sublime-text-dev \
      dropbox droxi dropbox-cli \
      systemd-kcm \
      google-chrome \
      spotify ffmpeg-compat-54 \
      gitkraken 


## Make sure ~/.local/bin is in your $PATH
stack install --system-ghc \
      xmonad xmonad-contrib
      # cabal-install \


echo " ~~ Build xmonad :)"
