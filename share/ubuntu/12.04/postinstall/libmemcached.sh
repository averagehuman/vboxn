
libmc_version="1.0.9"
libmc_md5="d55761ad61b0fb6016fed4d2edb940a4"
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
cd libmemcached-$libmc_version
./configure
make
make install
ldconfig

