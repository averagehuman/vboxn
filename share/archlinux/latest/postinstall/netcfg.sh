
pacman -S netcfg --noconfirm

cat <<EOF > /etc/network.d/eth0
CONNECTION='ethernet'
DESCRIPTION='NATd interface'
INTERFACE='eth0'
IP='dhcp'
EOF

cat <<EOF > /etc/network.d/eth1
CONNECTION='ethernet'
DESCRIPTION='Host-only interface'
INTERFACE='eth1'
IP='static'
ADDR='${VBOXN_IP:-192.168.44.100}'
NETMASK='${VBOXN_NETMASK:-255.255.255.0}'
EOF

cat <<EOF > /etc/conf.d/netcfg

NETWORKS=(eth0 eth1)

EOF

sed -i 's/^DAEMONS=\(.*\) network \(.*\)/DAEMONS=\1 \2/' /etc/rc.conf
sed -i 's/^DAEMONS=\(.*\))$/DAEMONS=\1 net-profiles)/' /etc/rc.conf

