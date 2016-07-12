# docker-maxscale
Dockerized MaxScale for Galera Cluster Backend

##Run
With default settings for a 3 server configuration with default ports:

    docker run -d -p 3306:3306 \
        --name maxscale \
        -e BACKEND_SERVER_LIST="db01.myserver db02.myserver db03.myserver" \
        -e MAX_PASS="myMaxScalePassword" \
        toughiq/maxscale

##Build

        docker build -t toughiq/maxscale .
        
## Environment Defaults
    MAX_THREADS=4
        MaxThreads for MaxScale to run.
    MAX_USER="maxscale"
        MaxScale User in the cluster.
    MAX_PASS="myMaxScaleUserPass"
        MaxScale User password for the cluster.
    ENABLE_ROOT_USER=0
        Allow root access to the DB via MaxScale.
    DB_PORT=3306
        MySQL/MariaDB Port MaxScale is exposing.
    CLI_PORT=6603
        MaxScale CLI port.
    BACKEND_SERVER_LIST="server1 server2 server3"
        List of backend Servers MaxScale is connecting to.
    BACKEND_PORT_LIST="3306 3306 3306"
        Corresponding listening ports of backendservers for MaxScale to connect to.
        
__BACKEND_SERVER_LIST__ and __MAX_PASS__ have to be set on each `docker run` or within `docker-compose.yml`, since we cannot use defaults here.
