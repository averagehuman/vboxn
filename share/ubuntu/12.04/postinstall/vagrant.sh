
date > /etc/vagrant_box_build_time

useradd -m -G admin -r vagrant
passwd -d vagrant
passwd vagrant<<EOF
vagrant
vagrant
EOF
# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh

# Install Ruby from source in /opt so that users of Vagrant
# can install their own Rubies using packages or however.
cd /tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
tar xvzf ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194
./configure --prefix=/opt/ruby
make
make install
cd ..
rm -rf ruby-1.9.3-p194

# Install RubyGems 1.8.24
wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz
tar xzf rubygems-1.8.24.tgz
cd rubygems-1.8.24
/opt/ruby/bin/ruby setup.rb
cd ..
rm -rf rubygems-1.8.24

# Installing chef
/opt/ruby/bin/gem install chef --no-ri --no-rdoc

# Add /opt/ruby/bin to the global path as the last resort so
# Ruby, RubyGems, and Chef/Puppet are visible
echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/vagrantruby.sh

