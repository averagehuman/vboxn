
# mosh ssh terminal (server)
apt-get install -y mosh

ufw default deny
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

