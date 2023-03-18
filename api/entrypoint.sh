#!/bin/bash

# Start the SSH agent
eval "$(ssh-agent)"

# Add the private key to the SSH agent
echo "${PRIVATE_KEY}" | ssh-add -

# Establish the SSH tunnel
ssh -N -L ${SSH_TUNNEL_CLIENT_PORT}:${MYSQL_HOST_IP_OR_HOSTNAME}:${MYSQL_PORT} -p 22 ${SSH_USERNAME}@${MYSQL_HOST_IP_OR_HOSTNAME} &

# Store the SSH tunnel process ID
ssh_pid=$!

# Start the application using pm2-runtime
pm2-runtime start pm2.json

# Terminate the SSH tunnel when the application exits
kill $ssh_pid

