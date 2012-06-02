
# make sure network is up and a nameserver is available
dhcpcd eth0

# root password
passwd<<EOF
${VBOXEN_ROOT_PASSWORD:=vboxen}
${VBOXEN_ROOT_PASSWORD}
EOF

# sudo setup
# note: do not use tabs here, it autocompletes and borks the sudoers file
cat <<EOF > /etc/sudoers
root      ALL=(ALL)    ALL
%wheel    ALL=(ALL)    NOPASSWD: ALL
EOF

# make sure ssh is allowed
echo "sshd: ALL" > /etc/hosts.allow

# and everything else isn't
echo "ALL:  ALL" > /etc/hosts.deny

# make sure sshd starts
sed -i 's:^DAEMONS\(.*\))$:DAEMONS\1 sshd):' /etc/rc.conf

# set a package mirror
echo "Server = ${VBOXEN_PACKAGE_MIRROR:-ftp://ftp.archlinux.org/\$repo/os/\$arch}" >> /etc/pacman.d/mirrorlist

# no idea
rm -f /usr/bin/tzselect /usr/sbin/zdump /usr/sbin/zic

# update pacman
pacman -Syy
pacman -S --noconfirm pacman

# upgrade pacman db
pacman-db-upgrade
pacman -Syy

