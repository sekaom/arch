#!/bin/bash
source /root/step1.sh

echo "==========link vim to nvim========="
ln -s /bin/nvim /bin/vim
ln -s /bin/nvim /bin/vi

echo "=============set time=============="
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
hwclock --systohc

echo "============set language==========="
echo "en_US.UTF-8 UTF-8  
en_US ISO-8859-1
zh_CN.GB18030 GB18030  
zh_CN.GBK GBK  
zh_CN.UTF-8 UTF-8  
zh_CN GB2312" >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo "===========set host name==========="
echo "archlinux" >> /etc/hostname

read -p "==>Place enter a user name: " username
echo "===========set user name==========="
echo "
127.0.0.1 localhost
::1 localhost
127.0.1.1 $username.localdomain $username" >> /etc/hosts

echo "====which shell you want to use?==="
echo "           bash or zsh?"
echo "==================================="
read -p "==>shell: " shell
zsh=zsh
if [ "$shell" = "$zsh" ]
    then
        echo "============add new user==========="
        useradd -m -G wheel -s /bin/zsh $username
else
        echo "============add new user==========="
        useradd -m -G wheel -s /bin/bash $username
fi

echo "==========enable service==========="
systemctl enable iwd.service
systemctl enable systemd-resolved.service
systemctl enable bluetooth.service
systemctl enable NetworkManager
systemctl enable dhcpcd
systemctl enable gdm

echo "===========set network============="
echo "
[General]
EnableNetworkConfiguration=true
NameResolvingService=systemd" >> /etc/iwd/main.conf
echo "
[device]
wifi.backend=iwd" >> vim /etc/NetworkManager/NetworkManager.conf

echo "==========set fcitx5=============="
echo "
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
INPUT_METHOD=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus" >> /etc/environment

echo "==========set archlinuxcn========="
rm -rf /etc/pacman.conf
curl -LfsS "https://gitee.com/sekaom/arch/raw/master/pacman.conf" >> /etc/pacman.conf
pacman -Syyu
pacman -S archlinuxcn-keyring
pacman -S yay
pacman -S nerd-fonts-hack
chsh -s /usr/bin/zsh

echo "=============set sudo============="
echo "
%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo "===========install grub==========="
grub-install --target=x86_64-efi --efi-directory=$boot_partition --bootloader-id="Arch Linux"
grub-mkconfig -o /boot/grub/grub.cfg

echo "===========set password==========="
passwd root
passwd $username
