#!/bin/bash

# Container name
CONTAINER_NAME="deploy-node-1"

# Error filter
ERROR_FILTER="One of the blocks specified in filter"

# Command to restart the container
RESTART_COMMAND="docker restart ${CONTAINER_NAME}"

# File to store the number of restarts
RESTART_COUNT_FILE="/var/log/docker/${CONTAINER_NAME}_restart_count.log"

# Infinite loop
while true; do
    # Initialize restart counter if file does not exist
    if [ ! -f $RESTART_COUNT_FILE ]; then
        echo 0 > $RESTART_COUNT_FILE
    fi

    # Read container logs from the end (last 5 lines) and follow new entries
    docker logs --tail 5 -f $CONTAINER_NAME | while read line ; do
        echo "Line read: $line" # Debugging information
        echo "$line" | grep -q "$ERROR_FILTER"
        if [ $? = 0 ]; then
            echo "Error detected: $line"
            echo "Restarting container..."

            # Restarting container
            $RESTART_COMMAND

            # Increment restart counter
            RESTART_COUNT=$(cat $RESTART_COUNT_FILE)
            RESTART_COUNT=$((RESTART_COUNT + 1))
            echo $RESTART_COUNT > $RESTART_COUNT_FILE

            echo "Number of restarts: $RESTART_COUNT"
        fi
    done
done
