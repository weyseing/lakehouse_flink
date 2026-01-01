#!/bin/bash

# session name
SESSION_NAME=$1
if [ -z "$SESSION_NAME" ]; then
    echo "ERROR: Missing session name"
    exit 1
fi

# get flink session ID
SESSION_ID=$(yarn application -list | grep "$SESSION_NAME" | awk '{print $1}' | head -n 1)
if [ -z "$SESSION_ID" ]; then
    echo "Error: No session found with name '$SESSION_NAME'"
    exit 1
fi

# list jobs
flink list -t yarn-session -Dyarn.application.id=$SESSION_ID