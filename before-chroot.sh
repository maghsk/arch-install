source envs.rc

timedatectl set-ntp true
fdisk -l
lsblk
echo "EFI drive is:  ${EFI_DRIVE}"
echo "Root drive is:  ${ROOT_DRIVE}"
echo "Swap drive is:  ${SWAP_DRIVE}"
echo "user name is:  ${USERNAME}"
read -s -n1 -p "Press any key to continue ... "
# --- make EFI partition ---
# mkfs.fat -F32 $EFI_DRIVE
# --- use btrfs ---
mkfs.btrfs $ROOT_DRIVE
mount $ROOT_DRIVE /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
umount /mnt
mount -o compress=zstd,subvol=@root $ROOT_DRIVE /mnt
mkdir /mnt/{boot,var,home,.snapshots}
mount -o compress=zstd,subvol=@var $ROOT_DRIVE /mnt/var
mount -o compress=zstd,subvol=@home $ROOT_DRIVE /mnt/home
mount -o compress=zstd,subvol=@snapshots $ROOT_DRIVE /mnt/.snapshots
# --- end btrfs ---

mkdir /mnt/boot
mount $EFI_DRIVE /mnt/boot
swapon $SWAP_DRIVE

# sed -i "s/#*\(.*https.*tuna.*$\)/\1/g" /etc/pacman.d/mirrorlist
echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirrors.huaweicloud.com/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirrors.163.com/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
mkdir /mnt/arch-install
cp ./* /mnt/arch-install/
arch-chroot /mnt
