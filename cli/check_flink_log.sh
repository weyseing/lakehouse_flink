#!/bin/bash

# app ID
APP_ID=$1
if [ -z "$APP_ID" ]; then
    echo "No Flink Application ID provided. Please check application ID below"
    yarn application -list
    exit 1
fi

LINES=${2:-100}
yarn logs -applicationId "$APP_ID" | tail -n "$LINES"