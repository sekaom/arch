timedatectl set-ntp true
echo "sync time"
mkfs.fat -F32 /dev/sda1
echo "format /dev/sda1"
mkswap /dev/sda2
echo "format swap"
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4
echo "format home and root"
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt 
mount /dev/sda4 /mnt/home
swapon /dev/sda2 
lsblk
sleep 10
rm -rf /etc/pacman.d/mirrorlist
echo "
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch
Server = https://mirrors.cloud.tencent.com/archlinux/$repo/os/$arch
#Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
pacman -Sy
echo "change mirrorlist"
sleep 5
echo "install packages..."
pacman -S archlinux-keyring
pacstrap /mnt base linux linux-headers linux-firmware base-devel neovim iwd networkmanager ttf-dejavu sudo bluez nano usbmuxd dhcpcd ntfs-3g wqy-zenhei grub efibootmgr jdk17-openjdk jdk8-openjdk intel-ucode amd-ucode pulseaudio xorg pacman gnome fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-configtool zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions 
genfstab -U /mnt >> /mnt/etc/fstab
echo "gen fstab"
curl -LfsS "https://gitee.com/sekaom/arch/raw/master/2.sh" >> /mnt/root/2.sh
chmod a+x /mnt/root/2.sh
