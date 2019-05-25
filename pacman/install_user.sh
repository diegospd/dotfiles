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
     # davinci-resolve \
      gitkraken postman-bin \
      keepassx \
      leiningen \
      lib32-mesa blockout2 \
      masterpdfeditor-free


## Make sure ~/.local/bin is in your $PATH
stack install --system-ghc \
      xmonad xmonad-contrib \
      turtle \
      cabal-install \
      alex happy hlint

cabal update
cabal install monky


echo " ~~ Build xmonad :)"
