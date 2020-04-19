source envs.rc

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen
echo 'zh_TW.UTF-8 UTF-8' >> /etc/locale.gen
echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen

echo $HOSTNAME > /etc/hostname

echo "127.0.0.1	localhost" >> /etc/hosts
echo "127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
cat hosts >> /etc/hosts

echo "LANG=en_US.UTF-8" > /etc/locale.conf

pacman -S linux-firmware intel-ucode grub efibootmgr os-prober --noconfirm
# pacman -S dialog --noconfirm
# pacman -S linux-lts --noconfirm
mkinitcpio -p linux
passwd
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH-`date +%F`
grub-mkconfig -o /boot/grub/grub.cfg
# pacman -S gdm gnome gnome-extra --noconfirm
pacman -S kdeutils plasma plasma-wayland-session sddm kdebase --noconfirm
pacman -S nano vim git gcc clang curl wget python jdk-openjdk --noconfirm
pacman -S nvidia nvidia-utils snapper firefox-developer-edition-i18n-zh-cn --noconfirm
systemctl enable sddm NetworkManager
# systemctl enable NetworkManager gdm
cat blacklist.conf >> /etc/modprobe.d/blacklist.conf

useradd -U $USERNAME -m
sudo gpasswd -a $USERNAME input
sudo gpasswd -a $USERNAME wheel
# sudo gpasswd -a $USERNAME bumblebee
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
