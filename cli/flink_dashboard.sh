#!/bin/bash

# args
INSTANCE_ID=$1
REMOTE_HOST=$2  
REMOTE_PORT=$3  
LOCAL_PORT=$4  
AWS_PROFILE=$5
REGION="ap-southeast-1"

# check args
if [ -z "$INSTANCE_ID" ] || [ -z "$REMOTE_HOST" ] || [ -z "$REMOTE_PORT" ] || [ -z "$LOCAL_PORT" ] || [ -z "$AWS_PROFILE" ]; then
    echo "Usage: $0 <INSTANCE_ID> <REMOTE_HOST_IP> <REMOTE_PORT> <LOCAL_PORT> <AWS_PROFILE>"
    echo "Example: $0 i-022fa43cdc8911111 172.16.15.115 35265 8081 ssh"
    exit 1
fi

# ssm port forwarding
aws ssm start-session \
    --profile "$AWS_PROFILE" \
    --region "$REGION" \
    --target "$INSTANCE_ID" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters "{\"host\":[\"$REMOTE_HOST\"],\"portNumber\":[\"$REMOTE_PORT\"],\"localPortNumber\":[\"$LOCAL_PORT\"]}"