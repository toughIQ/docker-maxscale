FROM asosso/maxscale:1.4.3
MAINTAINER toughiq@gmail.com

# Setup for Galera Service (GS), not for Master-Slave environments

# We set some defaults for config creation. Can be overwritten at runtime.
ENV MAX_THREADS=4 \
    MAX_USER="maxscale" \
    MAX_PASS="myMaxScaleUserPassword" \
    ENABLE_ROOT_USER=0 \ 
    DB_PORT=3306 \
    CLI_PORT=6603 \
    BACKEND_SERVER_LIST="server1 server2 server3" \
    BACKEND_PORT_LIST="3306 3306 3306"

# We copy our config creator script to the container
COPY docker-entrypoint.sh /

# We expose our set Listener Ports
EXPOSE $DB_PORT $CLI_PORT

# We define the config creator as entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

# We startup MaxScale as default command
CMD ["/usr/bin/maxscale","--nodaemon"]
