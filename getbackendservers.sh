#!/bin/bash
getent hosts tasks.$DB_SERVICE_NAME|awk '{print $1}'|sort|tr '\n' ' '