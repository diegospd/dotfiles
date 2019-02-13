#!/bin/bash

aurman -Syyu --needed --noconfirm --noedit \
      aurman \
      xmeasure \
      sublime-text-dev \
      dropbox droxi dropbox-cli \
      systemd-kcm \
      diskmonitor \
      google-chrome \
      spotify ffmpeg-compat-54 \
      gitkraken postman-bin \
      leiningen \
      lib32-mesa \
      masterpdfeditor-free


## Make sure ~/.local/bin is in your $PATH
stack install --system-ghc \
      xmonad xmonad-contrib \
      turtle \
      cabal-install \
      alex happy hlint

cabal update
# cabal install hsdev ghc-mod


echo " ~~ Build xmonad :)"
