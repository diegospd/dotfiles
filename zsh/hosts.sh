alias ada='ssh -D 8080 dmurillo@ada.fciencias.unam.mx'


hack() {
  ssh 192.168.100.$1
}

link-namek() {
	sshfs diego@192.168.100.$1:/home/diego /mnt/namek -C
}

link-bob() {
	sshfs diego@192.168.100.$1:/home/diego /mnt/bob -C
}


link-psyduck() {
	sshfs diego@192.168.100.$1:/mnt/psyduck /mnt/psyduck -C
}


