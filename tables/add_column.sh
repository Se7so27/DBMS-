#!/bin/bash
db_path=$1
# list databases and list tables in a database
# check if db_path is valid
if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi
tables=$(ls -A "$db_path")
if [[ -z "$tables" ]]; then
    echo "[LOG]: No tables"
else
    echo "Tables in database:"
    ls -1 "$db_path"
fi
return 0
