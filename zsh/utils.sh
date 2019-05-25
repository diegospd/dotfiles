


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


extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                   c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
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
