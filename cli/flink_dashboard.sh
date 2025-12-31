#!/bin/bash

# env
export $(grep -v '^#' .env | xargs)

# session name
SESSION_NAME=$1
if [ -z "$SESSION_NAME" ]; then
    echo "Error: No Flink Session name provided."
    exit 1
fi

# tracking url, ip, port
RAW_URL=$(./cli/ssh_primary_node.sh "yarn application -list" | grep "$SESSION_NAME" | grep -o "http://[^ ]*")
if [ -z "$RAW_URL" ]; then
    echo "Error: Could not extract URL for $SESSION_NAME"
    exit 1
fi
REMOTE_IP=$(echo "$RAW_URL" | cut -d'/' -f3 | cut -d':' -f1)
REMOTE_PORT=$(echo "$RAW_URL" | cut -d':' -f3 | tr -dc '0-9')

# display
echo "-------------------------------------------"
echo "Found Session: $SESSION_NAME"
echo "Internal IP  : $REMOTE_IP"
echo "Internal Port: $REMOTE_PORT"
echo "Local Link   : http://localhost:$REMOTE_PORT"
echo "-------------------------------------------"

# tunnel
exec ./cli/ssh_primary_node.sh "$REMOTE_PORT" "$REMOTE_IP" "$REMOTE_PORT"