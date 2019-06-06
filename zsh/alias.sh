
# postman-bin lib32-mesa blockout2
alias aurUpdate='aurman -S aurman \
                         systemd-kcm \
                         diskmonitor \
                         google-chrome vivaldi chromium-widevine \
                         dropbox dropbox-cli droxi \
                         gitkraken sublime-text-dev \
                         leiningen stack-bin \
                         spotify ffmpeg-compat-54 \
                         popcorntime plex-media-player \
                         hamster-time-tracker safeeyes \
                         masterpdfeditor-free \
                         xmeasure \
                         pyrenamer \
                         keepassx \
                         --noconfirm --noedit --needed'
# ninjutsu
alias pulse-reinit='pulseaudio -k ; pulseaudio -D]'

## Temp
alias cd.='cd $DOTFILES'
alias cdx='cd $HOME/.xmonad/'
alias cd.x='cd $DOTFILES/xmonad/my-xmonad/'
alias cd.z='cd $DOTFILES/zsh/'

alias cdnu='cd $NU_HOME'
alias cdel='cd $NU_HOME/el-surrender/'
alias lintPush='lein lint-fix && git add . && git commit -m "+lein lint-fix" && git push'


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
alias router='ip route | grep default'
prende() {
  sudo mount /dev/mapper/shelf4tb /mnt/shelf && \
  sudo systemctl start emby-server.service
  kb
}
