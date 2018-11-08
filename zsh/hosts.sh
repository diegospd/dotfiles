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
