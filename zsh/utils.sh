#!/bin/bash


alias ..='cd ..'
alias :r='source ~/.zshrc'

# test network connection
alias red='ping -c 3 www.google.com'


## borra todos los archivos de 0  bytes
alias borravacio='find . -size 0c -delete'

# cuenta cuantos archivos y carpetas hay
alias cuenta='expr `ls -l | wc -l` - 1'

## Delete all files of size zero
alias sopla='find . -size 0c -delete'


## Recibe el valor mas grande
## https://unix.stackexchange.com/questions/236164/how-to-find-missing-files-with-sequential-names
missing () {
  ub=$(ls | sort -n | tail -n 1 | xargs basename -s .jpg)
  seq "$ub" | while read -r i; do
    [[ -f "$i.jpg" ]] || echo "$i.jpg is missing"
  done
}


 ## Remove orphan pacman packages
orphans() {
  if [[ ! -n $(pacman -Qdt) ]]; then
    echo no orphans to remove
  else
    sudo pacman -Rs $(pacman -Qdtq)
  fi
}





# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux#5947802
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

function info {
  echo "${blue}$1${reset}"
}

function attention {
  echo "${green}$1${reset}"
}

function warning {
  echo "${red}$1${reset}"
}

function is_installed {
  command -v $1
}
