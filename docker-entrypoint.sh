#!/bin/bash

set -e

# We break our IP and Port list into arrays
IFS=', ' read -r -a backend_servers <<< "$BACKEND_SERVER_LIST"
IFS=', ' read -r -a backend_ports <<< "$BACKEND_PORT_LIST"

if [ "${#backend_servers[@]}" -ne "${#backend_ports[@]}" ];then
  echo "Number of definded BackendServer:${#backend_servers[@]} does not match"
  echo "Number of definded BackendPorts:${#backend_ports[@]}"
  echo "Exiting!"
  exit 1
fi



config_file="/etc/maxscale.cnf"

# We start config file creation

cat <<EOF > $config_file
[maxscale]
threads=$MAX_THREADS

[Galera Service]
type=service
router=readconnroute
router_options=synced
servers=${BACKEND_SERVER_LIST// /,}
user=$MAX_USER
passwd=$MAX_PASS
enable_root_user=$ENABLE_ROOT_USER

[Galera Listener]
type=listener
service=Galera Service
protocol=MySQLClient
port=3306

[Galera Monitor]
type=monitor
module=galeramon
servers=${BACKEND_SERVER_LIST// /,}
user=$MAX_USER
passwd=$MAX_PASS

[CLI]
type=service
router=cli
[CLI Listener]
type=listener
service=CLI
protocol=maxscaled
port=6603

# Start the Server block
EOF

# add the [server] block
for i in ${!backend_servers[@]}; do
cat <<EOF >> $config_file
[${backend_servers[$i]}]
type=server
address=${backend_servers[$i]}
port=${backend_ports[$i]}
protocol=MySQLBackend

EOF

done


exec "$@"

