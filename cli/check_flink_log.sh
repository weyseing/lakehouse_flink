#!/bin/bash

# session ID
SESSION_ID=$1
if [ -z "$SESSION_ID" ]; then
    echo "No Session ID provided. Searching for the latest Flink session..."
    yarn application -list
    exit 0
fi

LINES=${2:-100}
yarn logs -applicationId "$SESSION_ID" | tail -n "$LINES"