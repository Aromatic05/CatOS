#!/usr/bin/env bash

## Script to perform several important tasks before `mkarchcraftiso` create filesystem image.

set -e -u

## -------------------------------------------------------------- ##
## 更换国内源
echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.cernet.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.xjtu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.shanghaitech.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

## -------------------------------------------------------------- ##
##更换主机名
echo "CatOS" > /etc/hostname
## -------------------------------------------------------------- ##

## -------------------------------------------------------------- ##
## 修改pacman.conf
sed -i 's/Color/Color\nILoveCandy/' /etc/pacman.conf

### 开启multilib仓库支持
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
echo ' ' >> /etc/pacman.conf
## 增加archlinuxcn源
echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
echo 'Server = https://mirror.nju.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf

## -------------------------------------------------------------- ##

## 增加arch4edu源
echo '[arch4edu]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = https://mirrors.cernet.edu.cn/arch4edu/$arch' >> /etc/pacman.conf
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/arch4edu/$arch' >> /etc/pacman.conf
echo 'Server = https://mirror.nju.edu.cn/arch4edu/$arch' >> /etc/pacman.conf

## -------------------------------------------------------------- ##

## 增加catos源
echo '[catos]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = https://pkgs.catos.info/$arch' >> /etc/pacman.conf

## -------------------------------------------------------------- ##

## 增加catos-extra源
echo '[catos-extra]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = file:///var/catos-extra/' >> /etc/pacman.conf

## -------------------------------------------------------------- ##

#pip install questionary
#设置时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

#设置系统语言为中文
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
cat > "/etc/locale.conf" <<- _EOF_
LANG=zh_CN.UTF-8
LC_ADDRESS=zh_CN.UTF-8
LC_IDENTIFICATION=zh_CN.UTF-8
LC_MEASUREMENT=zh_CN.UTF-8
LC_MONETARY=zh_CN.UTF-8
LC_NAME=zh_CN.UTF-8
LC_NUMERIC=zh_CN.UTF-8
LC_PAPER=zh_CN.UTF-8
LC_TELEPHONE=zh_CN.UTF-8
LC_TIME=zh_CN.UTF-8
_EOF_

#enable networkmanager
ln -s '/usr/lib/systemd/system/NetworkManager.service' '/etc/systemd/system/multi-user.target.wants/NetworkManager.service'
#enable docker
ln -s '/usr/lib/systemd/system/docker.service' '/etc/systemd/system/multi-user.target.wants/docker.service'

#optimize the VM experience
ln -s /usr/lib/systemd/system/vboxservice.service /etc/systemd/system/multi-user.target.wants/vboxservice.service
ln -s /usr/lib/systemd/system/vmtoolsd.service /etc/systemd/system/multi-user.target.wants/vmtoolsd.service
ln -s /usr/lib/systemd/system/vmware-networks.service /etc/systemd/system/multi-user.target.wants/vmware-networks.service
ln -s /usr/lib/systemd/system/vmware-vmblock-fuse.service /etc/systemd/system/multi-user.target.wants/vmware-vmblock-fuse.service

#remove kde welcome
#rm /etc/xdg/autostart/org.kde.plasma-welcome.desktop
rm /etc/xdg/autostart/calamares.desktop

mkdir /home/liveuser/Desktop
mv /etc/xdg/autostart/catos.desktop /home/liveuser/Desktop/catos.desktop
#rm /etc/xdg/autostart/catos-advanced.desktop  #暂时移除联网安装
mv /etc/xdg/autostart/catos-advanced.desktop /home/liveuser/Desktop/catos-advanced.desktop


sed -i 's/#Color/Color/g' /etc/pacman.conf


#sed -i 's/MODULES=()/MODULES=(vsock vmw_vsock_vmci_transport vmw_balloon vmw_vmci vmwgfx)/g' /etc/mkinitcpio.conf
#mkinitcpio -p linux


##fcitx5
echo "GTK_IM_MODULE=fcitx" >> /etc/environment
echo "QT_IM_MODULE=fcitx" >> /etc/environment
echo "XMODIFIERS=@im=fcitx" >> /etc/environment
echo "SDL_IM_MODULE=fcitx" >> /etc/environment


##grub
#echo 'GRUB_THEME="/usr/share/grub/themes/vimix-color-1080p/theme.txt"' >> /etc/default/grub
echo 'GRUB_THEME="/usr/share/grub/themes/catos-grub-theme-dark-1080p/theme.txt"' >> /etc/default/grub

echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub

###修改plymounth默认主题为catos  /usr/share/plymouth/plymouthd.defaults
#sed -i 's/bgrt/catos/g' /usr/share/plymouth/plymouthd.defaults

###sddm
#sed -i 's:Current=.*:Current=sugar-candy-catos:g' /etc/sddm.conf.d/kde_settings.conf

###修改默认为x
###sed -i 's:Session=.*:Session=plasmax11:g' /etc/sddm.conf.d/kde_settings.conf




