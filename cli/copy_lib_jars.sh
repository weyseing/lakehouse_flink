#!/bin/bash

# paths
SRC_DIR="../lib_jars/lib"
DEST_DIR="/usr/lib/flink/lib"

# copy jars
for jar in "$SRC_DIR"/*.jar; do
    filename=$(basename "$jar")
    
    # exclude
    if [[ "$filename" == *"s3-fs-presto"* || "$filename" == *"shaded-hadoop"* ]]; then
        echo "Skipping: $filename"
    else
        echo "Copying: $filename"
        sudo cp "$jar" "$DEST_DIR/"
    fi
done