#!/bin/bash

ln -s $HOME/Dropbox/multiworld-portal/pol_tree.json  $HOME/.pol_tree.json
git clone git@github.com:diegospd/pol.git

cd pol
stack setup
stack install
cd ..
rm -rf pol

