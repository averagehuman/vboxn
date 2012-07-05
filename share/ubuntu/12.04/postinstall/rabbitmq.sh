
if [ -z "$(grep "rabbitmq\.com" /etc/apt/sources.list)" ]; then
    echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
    wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
    apt-key add rabbitmq-signing-key-public.asc
    rm rabbitmq-signing-key-public.asc
    apt-get update
fi

apt-get -y install rabbitmq-server librabbitmq-dev

rabbitmqctl add_user vboxn vboxn
rabbitmqctl add_vhost vboxn
rabbitmqctl set_permissions -p vboxn vboxn ".*" ".*" ".*"



