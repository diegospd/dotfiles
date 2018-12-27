
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
alias resolution='xrandr | grep current'
alias x_start='xmonad-x86_64-linux &'
alias x_compile='stack exec xmonad-x86_64-linux -- --recompile'
alias x_death='killall dzen2 conky'
alias x_restart='stack exec xmonad-x86_64-linux -- --restart'
alias x_hugs='cd ~/.xmonad && stack exec ghci xmonad.hs'

alias aurLista='pacman -Qm'
alias mirrors='sudo reflector --verbose -l 300 -p https --sort rate --save /etc/pacman.d/mirrorlist'
alias hosts='sudo nano /etc/hosts'
prende() {
  sudo mount /dev/mapper/shelf4tb /mnt/shelf && \
  sudo systemctl start emby-server.service
  kb
}