# Arch Setup
Helpful guidance as always in the arch wiki and unicks.eu on youtube + wikiarch.de Anleitung für Einsteiger

If anything goes wrong after installation, boot live installer from usb, mount /dev/sda, change root and do what needs to be done

## 1. Wifi Setup
1. For the installation (temporary) use `wifi-menu` to connect to a wireless network, run `lspci -k` and `ip link` nevertheless and remember module and interface name

### 1.1 After finished installation on first boot
1. `sudo pacman -S networkmanager` Start Network Manager to wrap ethernet and wifi functionality `systemctl enable NetworkManager.service` then disable netctl (and ethernet if connected)
2. `systemctl disable netctl-auto@INTERFACENAME.service` (interface name can be obtained via `ip link` and usually starts with w, eg wlp3s0) and to disable ethernet service `sudo systemctl disable dhcpcd@enp1s0.service` -> reboot

## 2. Partitioning
1. Run `fdisk -l` or `lsblk` to list connected block devices
2. Decide where to install (eg sda) and run `fdisk /dev/sda` -> `n` for new partition -> `p` for primary -> `1` ->  when using ssd start first sector at 4096 (experimental) instead of 2048 -> `+xyG` size in gigabyte until last sector, keep about 6G for the swap partition (find out with lsblk how much gb, all gb minus 6gb would amount to)
3. Add swap partition: `n` -> `p` -> `2` -> Enter + Enter to use the remaining sectors as swap -> `t` change type of partition `2` -> `82` swap code
4. `p` to print incoming changes and `w` to write

## 3. Filesystem
1. `mkfs.ext4 -L {label} /dev/sda1` eg ROOT or ARCH
2. `mkswap -L {label} /dev/sda2` eg SWAP
3. `mount /dev/sda1 /mnt`
4. `swapon /dev/sda2`
5. Optional: `df -Th` and `free -h` to verify

## 4. Base installation
1. `vim /etc/pacman.d/mirrorlist` and sort mirrors after nearest physical location. These will later be copied so get them right
2. `pacstrap /mnt base base-devel grub`
3. Create tables for the partitions `genfstab -Up /mnt >> /mnt/etc/fstab`. Optional: `cat /mtn/etc/fstab` to verify

## 5. Configure system
1. Arch change root into the new system `arch-chroot /mnt`
2. Install `pacstrap -i /mnt dialog wpa_supplicant`/`pacman -S dialog wpa_supplicant` (to use wifi-menu when booting into real OS)!! . linux-firmware?
3. Set hostname `echo {hostname} > /etc/hostname` 
4. Set locale (for dates, currencies etc) `echo LANG=en_US.UTF-8 > /etc/locale.conf`
5. Timezone: `ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
6. Add user: `useradd -m -g users -G wheel,audio,video -s /bin/bash {username}` -> `passwd {username}` -> `EDITOR=nano visudo` (wasnt exported last time so use `sudo nano /etc/sudoers` when in doubt and do the same) search line "%wheel All=(All) All" and uncomment to give allow execution of any command by wheel user group -> Ctrl-o enter Ctrl-x [Remeber this and the pw!]
6. Generate locals `nano /etc/locale.gen` uncomment lines en US utf8 -> `locale-gen` (here you can also uncomment DE..)

## 6. Bootloader
1. `grub-mkconfig -o /boot/grub/grub.cfg`
2. `grub-install /dev/sda`

Exit & Reboot into new system :) 

## 7. After booting into new system
1. `ifconfig -a` -> no ip address, remember interface name and `sudo dhcpcd {interface}` -> `ping www.google.com` to verify, else see first part of this page
2. Optional: `sudo pacman -S bash-completion` -> logout & login
3. `sudo pacman -S acpid ntp cronie avahi` -> `sudo systemctl enable acpid.service avahi-daemon cronie ntpd`
4. `sudo ntpd -gq` to sync timezone -> `date` to verify` , if incorrect: `sudo timedatectl set-timezone Europe/Berlin`

## 8. Graphical UI
1. Display server: `sudo pacman -S xorg-server xorg-xinit xorg-apps`. After this .xinitrc is read on startup
3. Find out graphics card via `lspci -k | grep -A 2 -E "(VGA|3D)"`
2. On virtual-box: `sudo pacman -S virtualbox-guest-utils` -> `2`
3. The default vesa display driver will work with most video cards, but performance can be significantly improved and additional features harnessed by installing the appropriate driver for ATI, Intel, or NVIDIA products.
4. Find out necessary driver via Internet(Arch wiki etc)

## 9. Some things
1. `sudo pacman -S git`
2. Install yaourt:
`git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -si
cd ..`
3. `sudo pacman -S xterm termite nvim`

## 10. DE and Login Manager [Depends on what you want]
### 10.1 Openbox
1. `sudo pacman -S openbox` -> put `exec openbox-session` into .xinitrc
2. `cp -R /etc/xdg/openbox ~/.config/openbox/`
### 10.2 Herbstluftwm
1. `sudo pacman -S herbstluftwm`
2. `mkdir -p ~/.config/herbstluftwm` -> `cp /etc/xdg/herbstluftwm/autostart ~/.config/herbstluftwm/
3. "exec herbstluftwm --locked" into .xinitrc
4. `sudo pacman -S zsh` -> `chsh -s /bin/zsh` -> COMPLETELY logout and in!
5. `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
6. TODO change to $HOME in .zshrc etc, vim setup, fonts, installations, thats it?


LEAFPAD

## Maintance
1. run `ncdu`
2. `rm -rf ~/.cache/*`
3. `rm -rf ~/.local/share/Trash/files/*`
4. `rm -rf /var/cache/pacman/pkg/`
5. Recursively delete orphans and their configs `pacman -Rns $(pacman -Qtdq)`