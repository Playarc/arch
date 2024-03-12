clear

echo '\n\n\n\n\nStarting playarc custom arch installation...'

read -p "Press Enter to continue"
clear

echo 'Executing \'cat /sys/firmware/efi/fw_platform_size\'...'
cat /sys/firmware/efi/fw_platform_size

read -p "Press Enter to continue"
clear

WIFI_NETWORK_SSID='MagentaWLAN-KTUA'
echo 'iwctl will be started to connect to WIFI. Please enter the password for '$WIFI_NETWORK_SSID
iwctl
station wlan0 connect MagentaWLAN-KTUA
exit

read -p "Press Enter to continue"
clear

echo '\nCheck internet connection...'
ping -c 5 google.com

read -p "Press Enter to continue"
clear

echo '\nExecuting \'timedatectl set-ntp true\''
timedatectl set-ntp true
echo 'Executing \'timedatectl status\''
timedatectl status

read -p "Press Enter to continue"
clear

DevBoot = /dev/nvme0n1p1
DevSwap = /dev/nvme0n1p2
DevRoot = /dev/nvme0n1p3
DevHome = /dev/nvme1n1p1

lsblk -f

echo '\n'
echo 'DevBoot=' $DevBoot
echo 'DevSwap=' $DevSwap
echo 'DevRoot=' $DevRoot
echo 'DevHome=' $DevHome

read -p "Press Enter to continue"

echo '\nDisk formatting...'
mkfs.fat -F32 $DevBoot
read -p "Press Enter to continue"
mkswap $DevSwap -L ArchSwap
read -p "Press Enter to continue"
mkfs.ext4 $DevRoot -L ArchRoot
read -p "Press Enter to continue"
#mkfs.ext4 $DevHome -L ArchHome

echo '\nDisk mounting...'
mount $DevRoot /mnt
read -p "Press Enter to continue"
swapon $DevSwap
read -p "Press Enter to continue"
mount --mkdir $DevBoot /mnt/boot
read -p "Press Enter to continue"
mount $DevHome /mnt/home
read -p "Press Enter to continue"

echo '\n'
lsblkf -f

read -p "Press Enter to continue"
clear

echo '\nExecuting \'pacstrap\''
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode vim git sudo networkmanager bluez go wget man-db man-pages neofetch 

read -p "Press Enter to continue"
clear

echo '\nExecuting \'genfstab -U /mnt >> /mnt/etc/fstab\''
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

read -p "Press Enter to continue"
clear

echo '\nExecuting \'arch-chroot /mnt\''
arch-chroot /mnt

read -p "Press Enter to continue"
clear

echo '\nExecuting \'ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime\''
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

read -p "Press Enter to continue"
clear

echo '\nExecuting \'Locale preparing (en_US.UTF-8)...\''
echo en_US.UTF-8 > /etc/locale.gen
echo '/etc/locale.gen file:'
cat /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo '/etc/locale.conf file:'
cat /etc/locale.conf

read -p "Press Enter to continue"
clear

echo arch > /etc/hostname
echo '/etc/hostname file:'
cat /etc/hostname

read -p "Press Enter to continue"
clear

echo "127.0.0.1\tlocalhost" >> /etc/hosts
echo "::1\tocalhost" >> /etc/hosts
echo "127.0.1.1\tarch.localdomain\tarch" >> /etc/hosts
echo '/etc/hosts file:'
cat /etc/hosts

read -p "Press Enter to continue"
clear

echo '\nExecuting \'mkinitcpio -P\''
mkinitcpio -P

read -p "Press Enter to continue"
clear

echo '\nEnter root password:'
passwd

read -p "Press Enter to continue"
clear

#pacman -S efibootmgr os-prober

read -p "Press Enter to continue"
clear

echo '\nExecuting \'bootctl --path/boot install\'...'
bootctl --path/boot install

read -p "Press Enter to continue"
clear

echo 'default\tarch.conf' >> /boot/loader/loader.conf
echo 'timeout\t3' >> /boot/loader/loader.conf
echo 'console-mode\tmax' >> /boot/loader/loader.conf
echo 'editor\tno' >> /boot/loader/loader.conf
cat /boot/loader/loader.conf

read -p "Press Enter to continue"
clear

touch /boot/loader/entries/arch.conf
echo 'title\tArch Linux' >> /boot/loader/entries/arch.conf
echo 'linux\t/vmlinuz-linux' >> /boot/loader/entries/arch.conf
echo 'initrd\t/intel-ucode.img' >> /boot/loader/entries/arch.conf
echo 'initrd\t/initramfs-linux.img' >> /boot/loader/entries/arch.conf
echo 'options\t/root=UUID==PUT_HERE_ARCH_ROOT_UUID rw' >> /boot/loader/entries/arch.conf

vim /boot/loader/entries/arch.conf

cat /boot/loader/loader.conf

read -p "Press Enter to continue"
clear

cat /boot/loader/entries/arch.conf

read -p "Press Enter to continue"
clear

echo '\nUser creating:'
#useradd -mG wheel playarc
useradd -G wheel playarc
echo '\nEnter user password:'
passwd playarc
EDITOR=vim visudo
visudo
chown -R playarc: /home/playarc

read -p "Press Enter to continue"
clear

echo '\nEnabling of NetworkManager.service...'
systemctl enable NetworkManager.service
echo '\nEnabling of bluetooth.service...'
systemctl enable bluetooth.service

read -p "Press Enter to continue"
clear

exit
umount /mnt -R
reboot
