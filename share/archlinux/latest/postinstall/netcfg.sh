
pacman -S netcfg

cat <<EOF > /etc/network.d/nat
CONNECTION='ethernet'
DESCRIPTION='NATd interface'
INTERFACE='eth0'
IP='dhcp'
EOF

cat <<EOF > /etc/network.d/hostonly
CONNECTION='ethernet'
DESCRIPTION='Host-only interface'
INTERFACE='eth1'
IP='static'
ADDR='${VBOXEN_IP:-192.168.44.10}'
NETMASK='${VBOXEN_NETMASK:-255.255.255.0}'
EOF

cat <<EOF > /etc/conf.d/netcfg

NETWORKS=(nat hostonly)

EOF

sed -i 's/^DAEMONS=\(.*\) network \(.*\)/DAEMONS=\1 \2/' /etc/rc.conf
sed -i 's/^DAEMONS=\(.*\))$/DAEMONS=\1 net-profiles)/' /etc/rc.conf

