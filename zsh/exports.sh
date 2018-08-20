#!/bin/bash

export PATH=$PATH:~/.dotfiles/bin
export PATH=$PATH:~/.local/bin/:/~/.cabal/bin
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

export EDITOR=nano
export VBOX_USB=usbfs
export SVN_EDITOR=nano


export JAVA_HOME=/usr/lib/jvm/java-7-openjdk/
export GEOSERVER_HOME=~/storage/codigos/mapitas/geoserver-2.8.3
export HADOOP_HOME=~/storage/codigos/hadoop
