#!/bin/bash

alias ..='cd ..'
alias sx='subl3'
alias ghci="stack --system-ghc exec ghci"
alias x_start='stack --system-ghc exec xmonad -- --replace &'
alias x_restart='stack --system-ghc exec xmonad -- --restart'
alias x_compile='stack --system-ghc exec xmonad -- --recompile'
# alias xxk='killall conky dzen2'
# alias xxx='xmonad --recompile && xmonad --restart'
## borra todos los archivos de 0  bytes
alias borravacio='find . -size 0c -delete'
alias cuenta='expr `ls -l | wc -l` - 1'


#--------------------------------------------------------------
#           c o n e x i o n e s    r e m o t a s 
#--------------------------------------------------------------


alias ada='ssh -D 8080 dmurillo@ada.fciencias.unam.mx'


hack() {
  ssh 192.168.100.$1
}

gkmount() {
  sshfs diego@192.168.100.$1:/home/diego /mnt/bob/ -C -o nonempty
}

gkumount() {
  fusermount -u /mnt/bob
}
