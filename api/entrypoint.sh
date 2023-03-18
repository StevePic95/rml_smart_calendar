#!/bin/bash

# Start the SSH agent
eval "$(ssh-agent)"

# add EC2 to known_hosts
ssh-keyscan ${MYSQL_HOST_IP_OR_HOSTNAME} >> ~/.ssh/known_hosts

# Establish the SSH tunnel
ssh -N -L 127.0.0.1:${SSH_TUNNEL_CLIENT_PORT}:${MYSQL_HOST_IP_OR_HOSTNAME}:${MYSQL_PORT} -p 22 -i /root/.ssh/id_rsa ${SSH_USERNAME}@${MYSQL_HOST_IP_OR_HOSTNAME} &

# Store the SSH tunnel process ID
ssh_pid=$!

# Start the application using pm2-runtime
pm2-runtime start pm2.json --env production

# Terminate the SSH tunnel when the application exits
kill $ssh_pid

