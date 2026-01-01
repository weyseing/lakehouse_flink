#!/bin/bash

# env
export $(grep -v '^#' .env | xargs)

SESSION_NAME=$1
JOB_NAME=$2
SAVEPOINT_PATH="s3://${ICEBERG_S3_BUCKET}/${ICEBERG_S3_SAVEPOINT}/"

# session name & job name
if [ -z "$SESSION_NAME" ] || [ -z "$JOB_NAME" ]; then
    echo "Usage: ./cli/stop_flink_jobs.sh <session_name> <job_name>"
    exit 1
fi

# session ID
SESSION_ID=$(yarn application -list | grep "$SESSION_NAME" | awk '{print $1}' | head -n 1)
if [ -z "$SESSION_ID" ]; then
    echo "Error: Could not find session $SESSION_NAME"
    exit 1
fi

# flink job ID
FLINK_JOB_ID=$(flink list -t yarn-session -Dyarn.application.id=$SESSION_ID | grep "$JOB_NAME" | awk '{print $4}')
if [ -z "$FLINK_JOB_ID" ]; then
    echo "Error: Could not find job '$JOB_NAME' in session $SESSION_ID"
    exit 1
fi

# display
echo "Stopping Job: $JOB_NAME ($FLINK_JOB_ID)"
echo "Target Savepoint: $SAVEPOINT_PATH"

# stop job
flink stop -t yarn-session \
  -Dyarn.application.id=$SESSION_ID \
  --savepointPath $SAVEPOINT_PATH \
  $FLINK_JOB_ID