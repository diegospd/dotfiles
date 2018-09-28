#!/bin/bash

sudo pacman -S zsh ruby --needed
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -s ~/.dotfiles/zsh/,zshrc ~/.zshrc
chsh -s /bin/zsh
