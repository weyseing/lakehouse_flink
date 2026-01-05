#!/bin/bash

# args
INSTANCE_ID=$1
REMOTE_PORT=$2
LOCAL_PORT=$3
AWS_PROFILE_ARG=$4
REGION="ap-southeast-1"

# check args
if [ -z "$INSTANCE_ID" ] || [ -z "$REMOTE_PORT" ] || [ -z "$LOCAL_PORT" ]; then
    echo "Usage: $0 <INSTANCE_ID> <REMOTE_PORT> <LOCAL_PORT> [AWS_PROFILE]"
    echo "Example: $0 i-022fa43cdc891111 35265 8081 ssh"
    exit 1
fi

# check aws credentials
if ! aws sts get-caller-identity --profile "$AWS_PROFILE_ARG" --region "$REGION" > /dev/null 2>&1; then
    echo "Error: Authentication failed. Your session might be expired (check ~/.aws/credentials)."
    exit 1
fi

# ssm port forwarding
aws ssm start-session \
    --profile "$AWS_PROFILE_ARG" \
    --region "$REGION" \
    --target "$INSTANCE_ID" \
    --document-name AWS-StartPortForwardingSession \
    --parameters "{\"portNumber\":[\"$REMOTE_PORT\"],\"localPortNumber\":[\"$LOCAL_PORT\"]}"