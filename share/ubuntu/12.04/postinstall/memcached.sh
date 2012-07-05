
libmc_version="1.0.8"
libmc_md5="b69eed80407c695c6ddca3b624e037a3"
libmc_url="https://launchpad.net/libmemcached/1.0/${libmc_version}/+download/libmemcached-${libmc_version}.tar.gz"

apt-get install libevent-dev cloog-ppl

cd /tmp

if [ ! -f libmemcached.tar.gz ]; then
    wget $libmc_url -O libmemcached.tar.gz
    if [ ! "$libmc_md5" = "$(md5sum libmemcached.tar.gz | awk '{print $1}')" ]; then
        echo "bad checksum $libmc_url"
        exit 1
    fi
fi

tar xzf libmemcached.tar.gz
cd libmemcached*
./configure
make
make install
ldconfig

apt-get -y install memcached

