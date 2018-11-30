
## Temp
alias nubank='cd ~/storage/codigos/chambas/nubank'
alias iswim='cd ~/storage/codigos/haskell/iswim'

alias ed='subl3'

# Git
alias add='git add'
alias chiclepega='git commit --amend -C HEAD && git push --force'
alias comovenga='git reset --hard HEAD~1 && git pull'

## Haskell
alias hugs="stack --system-ghc exec ghci -- -XOverloadedStrings"
alias curry="stack --system-ghc install"

## XMonad
alias x_start='xmonad-x86_64-linux --replace &'
alias x_restart='xmonad-x86_64-linux --restart'
alias x_compile='stack --system-ghc exec xmonad -- --recompile'

alias aurLista='pacman -Qm'


prende() {
  sudo mount /dev/mapper/shelf4tb /mnt/shelf && \
  sudo systemctl start emby-server.service
  kb
}
