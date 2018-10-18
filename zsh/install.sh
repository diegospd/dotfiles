#!/bin/bash

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

rm ~/.zshrc
ln -s ~/.dotfiles/zsh/,zshrc ~/.zshrc
source ~/.zshrc

echo "Great! Now install aurman and stack :)"
