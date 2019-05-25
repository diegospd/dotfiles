
export DOTFILES=$HOME/.dotfiles

export PATH=$PATH:~/.local/bin
export PATH=$PATH:$DOTFILES/bin/bin
# export PATH =$PATH:~/.cabal/bin

export EDITOR=nano
export VBOX_USB=usbfs
export SVN_EDITOR=nano

## Nubank's
export NU_HOME="${HOME}/dev/nu"  # folder where repos should be cloned; it's an arbitrary name, so change it if you wish
export NUCLI_HOME="${NU_HOME}/nucli"
export PATH="${NUCLI_HOME}:${PATH}"

# export JAVA_HOME=/usr/lib/jvm/java-7-openjdk
# export GEOSERVER_HOME=~/storage/codigos/mapitas/geoserver-2.8.3
# export HADOOP_HOME=~/storage/codigos/hadoop

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export GPG_TTY=$(tty)
