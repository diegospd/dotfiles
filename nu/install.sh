#!/bin/bash

## for yubikey support
sudo systemctl start pcscd.service 
sudo systemctl enable pcscd.service 

echo "choose jdk8-openjdk"
sudo pacman -S clojure rlwrap docker aws-cli jq nodejs intellij-idea-community-edition 
yay -S leiningen
