#!/bin/bash

# Establish the SSH tunnel using a private key
ssh -N -L ${SSH_TUNNEL_CLIENT_PORT}:${MYSQL_HOST_IP_OR_HOSTNAME}:${MYSQL_PORT} -p 22 -i ${PRIVATE_KEY} ${SSH_USERNAME}@${MYSQL_HOST_IP_OR_HOSTNAME} &

# Store the SSH tunnel process ID
ssh_pid=$!

# Start the application using pm2-runtime
pm2-runtime start pm2.json

# Terminate the SSH tunnel when the application exits
kill $ssh_pid

