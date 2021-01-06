#!/bin/bash

BACKEND_SERVER_LIST=`/getbackendservers.sh`
CONFIGURED_SERVER_LIST=`cat /tmp/configuredbackservers`

if [[ "$BACKEND_SERVER_LIST" == "$CONFIGURED_SERVER_LIST" ]]
then
	exit 0
else
	echo "$BACKEND_SERVER_LIST - $CONFIGURED_SERVER_LIST"
	exit 1
fi