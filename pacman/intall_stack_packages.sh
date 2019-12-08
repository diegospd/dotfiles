#!/bin/bash

## Make sure ~/.local/bin is in your $PATH
stack install --system-ghc \
      xmonad xmonad-contrib \
      turtle \
      cabal-install \
      alex happy hlint

cabal update
# cabal install hsdev ghc-mod

