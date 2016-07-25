# docker-maxscale
Dockerized MaxScale for Galera Cluster Backend

## Run
With default settings for a 3 server configuration with default ports:

    docker run -d -p 3306:3306 \
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
            DB_PORT=4407 \
            BACKEND_SERVER_LIST="maria01.db maria02.db maria03.db" \
            BACKEND_PORT="3306"
            
        docker build -t mymaxscale .
        docker run -d -p 3306:4407 
    
## Environment Defaults
    MAX_THREADS=4
        MaxThreads for MaxScale to run.
    MAX_USER="maxscale"
        MaxScale User in the cluster.
    MAX_PASS="maxscale"
        MaxScale User password for the cluster.
    ENABLE_ROOT_USER=0
        Allow root access to the DB via MaxScale. Values 0 or 1.
    DB_PORT=3306
        MySQL/MariaDB Port MaxScale is exposing.
    CLI_PORT=6603
        MaxScale CLI port.
        
    BACKEND_SERVER_LIST="server1 server2 server3"
        List of backend Servers MaxScale is connecting to.
    BACKEND_PORT="3306"
        Port on which the backend servers are listening.
        
__BACKEND_SERVER_LIST__ and __MAX_PASS__ have to be set on each `docker run` or within `docker-compose.yml`, since we cannot use defaults here.

## Service discovery with Docker Swarm 1.12
If the backend servers are running within a service controlled docker swarm you can start MaxScale also as service and let it autodiscover the DB nodes.
        docker service create --name maxscale \
            --network myDBnet \
            --env DB_SERVICE_NAME=my_db_service \
            --env BACKEND_PORT=4711 \
            toughiq/maxscale
    
    
    
