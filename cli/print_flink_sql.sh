#!/bin/bash

# print colors
GREEN='\033[0;32m'
NC='\033[0m'

# flink SQL file
SQL_FILE=$1
if [ -z "$1" ]; then
    echo "Error: No SQL file provided."
    echo "Usage: $0 <path_to_flink_sql_file>"
    exit 1
fi
if [ ! -f "$SQL_FILE" ]; then
    echo "Error: SQL file '$SQL_FILE' not found."
    exit 1
fi

# env
ENV_PATH="/lakehouse_flink/.env"
if [ -f "$ENV_PATH" ]; then
    set -a
    source "$ENV_PATH"
    set +a
else
    echo "Error: $ENV_PATH file not found."
    exit 1
fi

# replace env
VARS_TO_REPLACE=$(printf '$%s,' $(env | cut -d= -f1))
PROCESSED_SQL=$(envsubst "$VARS_TO_REPLACE" < "$SQL_FILE")

# print
echo -e "\n--- Processed Flink SQL: $SQL_FILE ---"
echo -e "${GREEN}${PROCESSED_SQL}${NC}"
echo -e "---------------------------\n"
