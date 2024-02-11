iwctl
station wlan0 connect MagentaWLAN-KTUA
exit

timedatectl set-ntp true
timedatectl status

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2 -L ArchSwap
mkfs.ext4 /dev/nvme0n1p3 -L ArchRoot

mount /dev/nvme0n1p3 /mnt
swapon /dev/nvme0n1p2
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
#mkdir /mnt/home
mount /dev/nvme1n1p1 /mnt/home

pacstrap -K /mnt base base-devel linux linux-firmware linux-headers intel-ucode vim git sudo networkmanager bluez bluez-utils go wget man-db man-pages neofetch grub os-prober efibootmgr man-db man-pages

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

vim /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

echo playarc_home_arch >> /etc/hostname

vim /etc/hosts
#127.0.0.1	localhost
#::1		localhost
#127.0.1.1	myhostname.localdomain	myhostname

mkinitcpio -P

passwd

useradd playarc -G wheel
visudo
passwd playarc
#mkdir /home/playarc
chown playarc:playarc /home/playarc -R
usermod -a -G wheel playarc

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager.service
systemctl enable bluetooth.service

exit
umount /mnt -R
reboot
