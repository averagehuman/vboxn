
# configure the hostonly adapter
cat >> /etc/network/interfaces <<EOF

# hostonly adapter interface
auto eth1
iface eth1 inet static
    address ${VBOXN_IP:-192.168.44.100}
    netmask ${VBOXN_NETMASK:-255.255.255.0}

EOF

# Setup sudo to allow no-password sudo for "admin"
groupadd -r admin
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# create SSH user 
if [ -n "$VBOXN_SSH_USER" ]; then
    useradd -m -G admin -r $VBOXN_SSH_USER
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

# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev
apt-get -y install vim
apt-get clean

# Installing the virtualbox guest additions
apt-get -y install dkms
VBOX_VERSION="${VBOX_VERSION:=4.1.18}"
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Install NFS client
apt-get -y install nfs-common

