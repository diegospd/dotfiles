BOB

Primeape: SSD 120 GB Kingston (antes Rama)

GPT partition table

NAME          FSTYPE      LABEL      UUID                                 FSAVAIL FSUSE% MOUNTPOINT
sdc                                                                                      
├─sdc1        vfat        EFI System CFAC-68AD                             233.7M    18% /boot
└─sdc2        crypto_LUKS            b69af768-8160-4451-8032-d1ea66b83992                
  └─bob-crypt ext4        root       36b5049d-2a72-4378-a479-4a484a3b5b50   74.4G    27% /


https://wiki.archlinux.org/index.php/Activating_Numlock_on_Bootup

KDE Plasma Users
Go to System Settings, under the Hardware/Input Devices/Keyboard item you will find an option to select the behavior of NumLock.

Plasma settings:
Desktop Behaviour > Screen Locking


Psyduck : HHD 8TB Luks
sdb           crypto_LUKS            ac258f0c-fc53-48bc-827f-d8c09dcd560d 

Raichu : HDD antes era shelf LUKS bob login
sda           crypto_LUKS            2c75ef25-9b7e-4ce4-b10d-b45c1d47013c               


https://blog.tinned-software.net/automount-a-luks-encrypted-volume-on-system-start/

sudo dd if=/dev/urandom of=/etc/luks-keys/pysduck_raichu_secret_key bs=512 count=8
sudo cryptsetup -v luksAddKey /dev/sdb /etc/lukk_raichu_secret_key 
sudo cryptsetup -v luksAddKey /dev/sda /etc/lukk_raichu_secret_key 
