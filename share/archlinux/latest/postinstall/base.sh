

# root password, default=vboxn
passwd<<EOF
${VBOXN_ROOT_PASSWORD:=vboxn}
${VBOXN_ROOT_PASSWORD}
EOF

# create SSH user 
if [ -n "$VBOXN_SSH_USER" ]; then
    useradd -m -G wheel -r $VBOXN_SSH_USER
    passwd -d $VBOXN_SSH_USER
passwd $VBOXN_SSH_USER<<EOF
vboxn
vboxn
EOF
fi

# create SSH user public key
if [ -n "$VBOXN_SSH_KEY" ]; then
    mkdir /home/${VBOXN_SSH_USER}/.ssh
    chmod 700 /home/${VBOXN_SSH_USER}/.ssh
    echo $VBOXN_SSH_KEY > /home/${VBOXN_SSH_USER}/.ssh/authorized_keys
    chmod 600 /home/${VBOXN_SSH_USER}/.ssh/authorized_keys
    chown -R ${VBOXN_SSH_USER}: /home/${VBOXN_SSH_USER}/.ssh
fi


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

# uncomment package mirrors, eg. patterns=heanet hosteurope hawaii
for pattern in $VBOXN_PACKAGE_MIRROR_PATTERNS; do
    sed -i 's/^#\(Server.*'${pattern}'.*\)/\1/g' /etc/pacman.d/mirrorlist
done

# set a fallback package mirror
echo "Server = ${VBOXN_PACKAGE_MIRROR:-ftp://ftp.archlinux.org/\$repo/os/\$arch}" >> /etc/pacman.d/mirrorlist

# no idea
rm -f /usr/bin/tzselect /usr/sbin/zdump /usr/sbin/zic

# update pacman
pacman -Syy
pacman -S --noconfirm pacman
pacman-key --init

# upgrade pacman db
#pacman-db-upgrade
pacman -Syuf

