#!/bin/bash

# session name
SESSION_NAME=$1
if [ -z "$SESSION_NAME" ]; then
    echo "Error: No Flink Session name provided."
    exit 1
fi

# find session ID
ID=$(yarn application -list | grep "$SESSION_NAME" | awk '{print $1}' | head -n 1)
if [ -z "$ID" ]; then
    echo "Error: No Flink Session found for '"$SESSION_NAME"'"
    exit 1
fi

# flink sql client
flink-sql-client embedded -Dexecution.target=yarn-session -Dyarn.application.id="$ID"