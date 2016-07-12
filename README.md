# docker-maxscale
Dockerized MaxScale for Galera Cluster Backend

##Run
With default settings for a 3 server configuration with default ports:

`docker run -d -p 3306:3306 \
    --name maxscale \
    -e BACKEND_SERVER_LIST="db01.myserver db02.mysserver db03.myserver" \
    -e MAX_PASS="myMaxScalePassword" \
    toughiq/maxscale`
