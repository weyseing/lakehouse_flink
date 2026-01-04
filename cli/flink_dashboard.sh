#!/bin/bash

# env
export $(grep -v '^#' ../.env | xargs)

# args
SESSION_NAME=$1
INSTANCE_ID=$2
LOCAL_PORT=$3
AWS_PROFILE_ARG=$4
REGION="ap-southeast-1"

# validate args
if [ -z "$SESSION_NAME" ] || [ -z "$INSTANCE_ID" ] || [ -z "$LOCAL_PORT" ] || [ -z "$AWS_PROFILE_ARG" ]; then
    echo "Error: Missing arguments."
    echo "Usage: ./flink_dashboard.sh <SESSION_NAME> <INSTANCE_ID> <LOCAL_PORT> <AWS_PROFILE>"
    echo "Example: ./flink_dashboard.sh session_iceberg_1 i-06907bbf06f5e4d93 8081 ssh"
    exit 1
fi

# tracking url, ip, port
REMOTE_PORT=$(aws ssm send-command \
    --profile "$AWS_PROFILE_ARG" \
    --region "$REGION" \
    --instance-ids "$INSTANCE_ID" \
    --document-name "AWS-RunShellScript" \
    --parameters "commands=['yarn application -list | grep $SESSION_NAME | grep -o \":[0-9]\{5\}\" | cut -d: -f2']" \
    --query "CommandInvocations[0].CommandPlugins[0].Output" \
    --output text | tr -d '\r' | xargs)
if [ -z "$REMOTE_PORT" ] || [ "$REMOTE_PORT" == "None" ]; then
    echo "Error: Could not retrieve YARN URL"
    exit 1
fi
echo "Found Remote Port: $REMOTE_PORT"
echo "Creating SSM tunnel: http://localhost:$LOCAL_PORT -> $INSTANCE_ID:$REMOTE_PORT"

# ssm port forwarding
aws ssm start-session \
    --profile "$AWS_PROFILE_ARG" \
    --region "$REGION" \
    --target "$INSTANCE_ID" \
    --document-name AWS-StartPortForwardingSession \
    --parameters "{\"portNumber\":[\"$REMOTE_PORT\"],\"localPortNumber\":[\"$LOCAL_PORT\"]}"