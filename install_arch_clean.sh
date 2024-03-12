WIFI_NETWORK_SSID='MagentaWLAN-KTUA'

echo '\n\n\n\n\nStarting playarc custom arch installation...'
echo 'iwctl will be started to connect to WIFI. Please enter the password for '$WIFI_NETWORK_SSID
iwctl
station wlan0 connect MagentaWLAN-KTUA
exit

echo '\nCheck internet connection...'
ping -c 5 google.com

echo '\nExecuting \'timedatectl set-ntp true\''
timedatectl set-ntp true
echo 'Executing \'timedatectl status\''
timedatectl status

echo '\nDisk formatting...'
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2 -L ArchSwap
mkfs.ext4 /dev/nvme0n1p3 -L ArchRoot

echo '\nDisk mounting...'
mount /dev/nvme0n1p3 /mnt
swapon /dev/nvme0n1p2
#mkdir -p /mnt/boot/efi
#mount /dev/nvme0n1p1 /mnt/boot/efi
mount /dev/nvme1n1p1 /mnt/home

echo '\nExecuting \'pacstrap\''
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode vim git sudo networkmanager bluez go wget man-db man-pages neofetch 

echo '\nExecuting \'genfstab -U /mnt >> /mnt/etc/fstab\''
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

echo '\nExecuting \'arch-chroot /mnt\''
arch-chroot /mnt

echo '\nExecuting \'ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime\''
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

echo '\nExecuting \'Locale preparing (en_US.UTF-8)...\''
echo en_US.UTF-8 > /etc/locale.gen
echo '/etc/locale.gen file:'
cat /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo '/etc/locale.conf file:'
cat /etc/locale.conf

echo arch > /etc/hostname
echo '/etc/hostname file:'
cat /etc/hostname

echo "127.0.0.1\tlocalhost" >> /etc/hosts
echo "::1\tocalhost" >> /etc/hosts
echo "127.0.1.1\tarch.localdomain\tarch" >> /etc/hosts
echo '/etc/hosts file:'
cat /etc/hosts

echo '\nExecuting \'mkinitcpio -P\''
mkinitcpio -P

echo '\nEnter root password:'
passwd

echo '\nUser creating:'
useradd playarc -G wheel
visudo
passwd playarc
#mkdir /home/playarc
chown playarc:playarc /home/playarc -R
usermod -a -G wheel playarc

echo '\nEnabling of NetworkManager.service...'
systemctl enable NetworkManager.service
echo '\nEnabling of bluetooth.service...'
systemctl enable bluetooth.service

exit
umount /mnt -R
reboot
