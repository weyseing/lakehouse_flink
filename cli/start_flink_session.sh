#!/bin/bash

# session name
SESSION_NAME=$1
if [ -z "$SESSION_NAME" ]; then
    echo "Error: No Flink Session name provided."
    exit 1
fi

flink-yarn-session -d -nm "$SESSION_NAME" \
  -D taskmanager.memory.process.size=4096m \
  -D taskmanager.numberOfTaskSlots=4 \
  -D state.backend=rocksdb \
  -D state.backend.incremental=true \
  -D state.checkpoint-storage=filesystem \
  -D state.checkpoints.dir=s3://confluent-kafka-rms/lakehouse/checkpoints/ \
  -D taskmanager.memory.managed.fraction=0.4 \
  -D table.exec.state.ttl=24h