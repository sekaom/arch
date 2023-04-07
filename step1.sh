#!/bin/bash
echo "========================================="
echo "        ArchLinux install script"
echo "          Produced by Sekaom"
echo "========================================="
echo  "==> start after 5s"
sleep 1
clear
lsblk
echo "==>Please enter the partition of the boot directory(such as '/dev/sda1')"
read -p " =>partiton: " boot_partition
echo "==>Please enter the partition of the swap directory(such as '/dev/sda2')"
read -p " =>partiton: " swap_partition
echo "==>Please enter the partition of the root directory(such as '/dev/sda3')"
read -p " =>partiton: " root_partition
echo "==>Please enter the partition of the /home directory(such as '/dev/sda4')"
read -p " =>partiton: " home_partition
echo "--------------"
echo "| boot: $boot_partition "
echo "| swap: $swap_partition "
echo "| root: $root_partition "
echo "| home: $home_partition "
read -p "All right(y or n)?" partition_sure
partition_sure_1=y
if [ "$partition_sure" = "$partition_sure_1" ]
    then
        break
else
        exit 1
fi

clear
echo "==========sync time============"
timedatectl set-ntp true

echo "========format partition======="
mkfs.fat -F32 $boot_partition
mkswap $swap_partition
mkfs.ext4 -F $root_partition
mkfs.ext4 -F $home_partition

echo "========mount partitions======="
mount $root_partition /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mkdir /mnt/home
mount $boot_partition /mnt/boot/efi
mount $home_partition /mnt/home
swapon $swap_partition
lsblk

echo "=======change mirrorlist======="
rm -rf /etc/pacman.d/mirrorlist
curl -LfsS "https://gitee.com/sekaom/arch/raw/master/mirrorlist" >> /etc/pacman.d/mirrorlist
pacman -Sy

read -p "Do you want tot install LTS kernel?(y or n)"  ltskernel
ltskernel1=y
echo "========Install Packages======="
if [ "$ltskernel" = "$ltskernel1" ]
    then
        pacman -S archlinux-keyring
        pacstrap /mnt base linux-lts linux-lts-headers linux-firmware base-devel \
        neovim iwd networkmanager ttf-dejavu sudo bluez nano usbmuxd dhcpcd \
        ntfs-3g wqy-zenhei grub efibootmgr jdk17-openjdk jdk8-openjdk intel-ucode amd-ucode \
        pulseaudio xorg pacman gnome fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-configtool \
        zsh zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel10k zsh-completions 
else
    pacman -S archlinux-keyring
    pacstrap /mnt base linux linux-headers linux-firmware base-devel \
    neovim iwd networkmanager ttf-dejavu sudo bluez nano usbmuxd dhcpcd \
    ntfs-3g wqy-zenhei grub efibootmgr jdk17-openjdk jdk8-openjdk intel-ucode amd-ucode \
    pulseaudio xorg pacman gnome fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-configtool \
    zsh zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel10k zsh-completions 
fi
echo "===========gen fstab==========="
genfstab -U /mnt >> /mnt/etc/fstab
echo "=====Download step2 script====="
curl  "https://gitee.com/sekaom/arch/raw/master/step2.sh" >> /mnt/root/step2.sh
chmod a+x /mnt/root/step2.sh

echo "================================================================="
echo "      The first step of installation has been completed "
echo "        Enter chroot-arch to proceed to the next step"
echo "Enter '/root/step2.sh' under chroot to continue the installation"
echo "================================================================="