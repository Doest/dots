
```sh
pacstrap -K /mnt base linux linux-firmware sof-firmware intel-ucode bluez bluez-utils networkmanager sudo zsh vim mesa intel-media-driver vulkan-intel tlp

echo -e "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p2) rw" > /boot/loader/entries/arch.conf

```