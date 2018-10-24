#!/bin/bash

aurman -S --needed --noconfirm \
      sublime-text-dev \
      dropbox droxi dropbox-cli \
      systemd-kcm \
      google-chrome \
      spotify ffmpeg-compat-54 \
      gitkraken postman


## Make sure ~/.local/bin is in your $PATH
stack install --system-ghc \
      xmonad xmonad-contrib turtle \
      cabal-install \
      alex happy hlint
cabal update
# cabal install hsdev ghc-mod


echo " ~~ Build xmonad :)"
