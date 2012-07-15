
apt-get -y install build-essential libreadline-dev autotools-dev libexpat1-dev
apt-get -y install zlib1g-dev libssl-dev libpcre3-dev libmhash-dev geoip-bin gettext
apt-get -y autoremove

if [ ! -f "$nginx_binary" ]; then

    nginx_name="nginx-$nginx_version"
    nginx_file="$nginx_name.tar.gz"
    nginx_url="http://nginx.org/download/$nginx_file"

    cd /tmp

    if [ ! -d $nginx_name ]; then
        wget $nginx_url -O $nginx_file
        tar xzf $nginx_file
        rm $nginx_file
    fi

    upload_module_version="2.2.0"
    upload_module_name="nginx_upload_module-$upload_module_version"
    upload_module_file="$upload_module_name.tar.gz"
    # needs latest - see github forks
    #upload_module_url="http://www.grid.net.ru/nginx/download/$upload_module_file"
    upload_module_url="https://github.com/podados/nginx-upload-module/tarball/2.2"

    if [ ! -d $upload_module_name ]; then
        wget $upload_module_url -O $upload_module_file
        tar xzf $upload_module_file
        mv podados-nginx-upload-* $upload_module_name
        rm $upload_module_file
    fi

    cd $nginx_name

    ./configure --prefix=$nginx_prefix \
                --sbin-path=$nginx_binary \
                --user=$nginx_user --group=$nginx_group \
                --with-http_ssl_module \
                --with-http_gzip_static_module \
                --with-http_realip_module \
                --with-http_geoip_module \
                --with-http_secure_link_module \
                --without-http_scgi_module \
                --without-http_ssi_module \
                --add-module=../$upload_module_name

    make
    make install
fi

