#!/bin/bash

set -e

HOSTNAME=`env hostname`
echo "Starting RabbitMQ Server For host: " $HOSTNAME

# Start RMQ from entry point.
# This will ensure that environment variables passed
# will be honored
/usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached
sleep 15
rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
# Do the cluster dance
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@rabbitmq1

# Stop the entire RMQ server. This is done so that we
# can attach to it again, but without the -detached flag
# making it run in the forground
rabbitmqctl stop

# Wait a while for the app to really stop
sleep 2s

# Start it
rabbitmq-server