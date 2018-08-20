#!/bin/bash

sudo pacman -S zsh ruby --needed
ln -s ~/.dotfiles/zsh/,zshrc ~/.zshrc
chsh -s /bin/zsh
