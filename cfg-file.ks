# https://docs.fedoraproject.org/en-US/fedora/f30/install-guide/appendixes/Kickstart_Syntax_Reference/

# Configure installation method
install
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-30&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f30&arch=x86_64" --cost=0
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-30&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-30&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-30&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-30&arch=x86_64" --cost=0

# zerombr
zerombr

# Configure Boot Loader
bootloader --location=mbr --driveorder=sda

# Create Physical Partition
part /boot --size=512 --asprimary --ondrive=sda --fstype=xfs
part swap --size=10240 --ondrive=sda
part / --size=8192 --grow --asprimary --ondrive=sda --fstype=xfs

# Remove all existing partitions
clearpart --all --drives=sda

# Configure Firewall
firewall --enabled --ssh

# Configure Network Interfaces
network --onboot=yes --bootproto=dhcp

# Configure Keyboard Layouts
keyboard us

# Configure Language During Installation
lang en_US

# Configure X Window System
xconfig --startxonboot

# Configure Time Zone
timezone Etc/GMT-4

# Create User Account
user --name=maxrom --password=$qwertynbvcxz --groups=wheel

# Set Root Password
rootpw $fedora

# Perform Installation in Text Mode
text

# Package Selection
%packages
@core
@standard
@hardware-support
@firefox
@fonts
@libreoffice
@multimedia
@networkmanager-submodules
@development-tools
@Python Classroom
@gnome-desktop
chromium
java-openjdk
vim
git
NetworkManager-openvpn-gnome
keepassx
gimp
calibre
tcpdump
ansible
vlc
gstreamer-plugins-ugly
gstreamer1-plugins-ugly
redhat-rpm-config
rpmconf
strace
wireshark
ffmpeg
readline-devel
zlib-devel
bzip2-devel
xz-devel
libcurl-devel
usbmuxd
transmission-gtk
evince
exfat-utils
fuse-exfat
icedtea-web
ristretto
argon2
%end

# Post-installation Script
%post

# Install Docker
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io
systemctl enable docker.service
systemctl start docker.service

# Install Jenkins
curl -o /usr/bin/jenkins_autostart.sh https://raw.githubusercontent.com/aakulgina/fedora/master/jenkins_autostart.sh
chmod +x /usr/bin/jenkins_autostart.sh
curl -o /etc/systemd/system/runjenkins.service https://raw.githubusercontent.com/aakulgina/fedora/master/runjenkins.service
chmod 644 /etc/systemd/system/runjenkins.service
systemctl enable runjenkins.service

# Harden sshd options
echo "" > /etc/ssh/sshd_config

#vimrc configuration
echo "filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set nohlsearch" > /home/sina/.vimrc

# Disable IPv6
cat <<EOF >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

# Enable services
systemctl enable usbmuxd

# Disable services
systemctl disable sssd
systemctl disable bluetooth.target
systemctl disable avahi-daemon
systemctl disable abrtd
systemctl disable abrt-ccpp
systemctl disable mlocate-updatedb
systemctl disable mlocate-updatedb.timer
systemctl disable gssproxy
systemctl disable bluetooth
systemctl disable geoclue
systemctl disable ModemManager
sed -i 's/Disabled=false/Disabled=true/g' /etc/xdg/tumbler/tumbler.rc
%end

# Reboot After Installation
# reboot --eject
