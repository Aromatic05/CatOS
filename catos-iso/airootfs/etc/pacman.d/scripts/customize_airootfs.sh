#!/usr/bin/env bash

## Script to perform several important tasks before `mkarchcraftiso` create filesystem image.

set -e -u

## 增加catos源
# echo '[catos]' >> /etc/pacman.conf
# echo 'SigLevel = Never' >> /etc/pacman.conf
# echo 'Server = https://pkgs.catos.info/$arch' >> /etc/pacman.conf

#remove kde welcome
rm /etc/xdg/autostart/calamares.desktop

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

mkdir -p /home/liveuser/Desktop
mv /etc/xdg/autostart/catos.desktop /home/liveuser/Desktop/catos.desktop
#rm /etc/xdg/autostart/catos-advanced.desktop  #暂时移除联网安装
mv /etc/xdg/autostart/catos-advanced.desktop /home/liveuser/Desktop/catos-advanced.desktop


##grub
#echo 'GRUB_THEME="/usr/share/grub/themes/vimix-color-1080p/theme.txt"' >> /etc/default/grub
echo 'GRUB_THEME="/usr/share/grub/themes/catos-grub-theme-dark-1080p/theme.txt"' >> /etc/default/grub

echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub




