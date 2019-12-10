#!/bin/bash

## for yubikey support
sudo systemctl start pcscd.service 
sudo systemctl enable pcscd.service 
sudo systemctl start docker.service
sudo systemctl enable docker.service

echo "choose jdk8-openjdk"
sudo pacman -S clojure rlwrap docker aws-cli jq nodejs intellij-idea-community-edition virtualbox
yay -S leiningen forticlientsslvpn


echo "you must agree to stuff. run this"
echo "sudo /opt/fortinet/forticlientsslvpn/helper/setup"
echo "connect to the vpn with:"
echo "forticlientsslvpn_cli --server newvpn.nubank.com.br:10443 --pkcs12 $NU_HOME/.nu/certificates/br/prod/network.p12"


echo "Adding a using to docker group is equivalent to root access"
# https://github.com/moby/moby/issues/9976
# https://docs.docker.com/engine/security/security/
sudo gpasswd -a $USER docker
