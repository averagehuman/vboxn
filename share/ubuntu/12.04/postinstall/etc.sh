
apt-get -y install ufw

ufw default deny
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

