# docker-maxscale
Dockerized MaxScale for Galera Cluster Backend.
Can be used in combination with https://github.com/toughIQ/docker-mariadb-cluster.

## Branches & Tags
There are 2 branches available, which feature __MaxScale1__ and __MaxScale2__ versions.

Since MaxScale1 is __free to use__, but MaxScale2 __needs a license from MariaDB__ in some setups, I will keep the __master__ branch with version 1.4.5 for now. This also applies to the __:latest__ tag in Docker.

| Version | Branch | Docker Tag |
|---------|--------|------------|
| _1.4.5_   | _master_ | _latest_     |
| 1.4.5   | 1.x    | 1          |
| 1.4.5   | 1.x    | 1.4.5      |
| 2.1.9   | 2.x    | 2          |
| 2.1.9   | 2.x    | 2.1.9      |

## Run
With default settings for a 3 server configuration with default ports:

    docker run -d -p 3306:3306 -p 3307:3307 \
        --name maxscale \
        -e BACKEND_SERVER_LIST="db01.myserver db02.myserver db03.myserver" \
        -e MAX_PASS="myMaxScalePassword" \
        toughiq/maxscale
### Using docker-compose
Check parameters in `docker-compose.yml` and start with:

    docker-compose up -d
    
## Build

        docker build -t toughiq/maxscale .

## Build own static image
You can build your own static image of __maxscale__, so you dont have to put your backend servers and credentials every time at the `run` command. Be aware __NOT__ to push this image into a public repository, since it contains your personal server/cluster credentials.

### Create Dockerfile Example

        FROM toughiq/maxscale
        MAINTAINER yourname@domain.com
        ENV MAX_PASS="yourMaxScalePassword" \
        MAX_THREADS=2 \
        ENABLE_ROOT_USER=1 \ 
        SPLITTER_PORT=4407 \
        ROUTER_PORT=4408 \
        BACKEND_SERVER_LIST="maria01.db maria02.db maria03.db" \
        BACKEND_SERVER_PORT="3306" \
        USE_SQL_VARIABLES_IN="all"
            
        docker build -t mymaxscale .
        docker run -d -p 3306:4407 -p 3307:4408 mymaxscale
    
## Environment Defaults
    MAX_THREADS=4
        MaxThreads for MaxScale to run.
    MAX_USER="maxscale"
        MaxScale User in the cluster.
    MAX_PASS="maxscalepass"
        MaxScale User password for the cluster.
    ENABLE_ROOT_USER=0
        Allow root access to the DB via MaxScale. Values 0 or 1.
    SPLITTER_PORT=3306
        MySQL/MariaDB Port MaxScale is exposing with the READWRITE service.
        Since this results in less errors when connecting, we made this the default on port 3306
    ROUTER_PORT=3307
        MySQL/MariaDB Port MaxScale is exposing with the READCONN service.
    CLI_PORT=6603
        MaxScale CLI port.
    CONNECTION_TIMEOUT=600
        Default timeout setting of 600sec/10min. If you need connections to be open for longer, just increase this value to the duration needed. Value is in seconds.
    PERSIST_POOLMAX=0
        Number of persistent connections to the backend server. Defaults to `0` which means no persistence. Change to `non-zero` value to enable given number of persistent connections.
    PERSIST_MAXTIME=3600
        If persistent backend connections are enabled, this is the timeout in `seconds`. After this period a connections is regarded as deprecated and will not be used again.
    BACKEND_SERVER_LIST="server1 server2 server3"
        List of backend Servers MaxScale is connecting to.
    BACKEND_SERVER_PORT="3306"
        Port on which the backend servers are listening.
    USE_SQL_VARIABLES_IN="all"
        Should SQL variables when using `readwritesplit` be routed to all nodes or just the master. Possible values `all` of `master`. Defaults to `all`
        Version 1: https://mariadb.com/kb/en/mariadb-enterprise/mariadb-maxscale-14/readwritesplit/
        Version 2: https://mariadb.com/kb/en/mariadb-enterprise/mariadb-maxscale-20-limitations-and-known-issues-within-mariadb-maxscale/
        
__BACKEND_SERVER_LIST__ and __MAX_PASS__ have to be set on each `docker run` or within `docker-compose.yml`, since we cannot use defaults here.

## Service discovery with Docker Swarm 1.12
If the backend servers are running within a service controlled docker swarm you can start MaxScale also as service and let it autodiscover each DB node running within service `my_db_service`
        
        docker service create --name maxscale \
            --network myDBnet \
            --env DB_SERVICE_NAME=my_db_service \
            toughiq/maxscale

This is done by querying the internal DNS service and processing the DNS round robin result to generate `maxscale.cnf` at startup.     
    
    
