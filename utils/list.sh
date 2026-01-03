#!/bin/bash
db_path=$1
# list databases and list tables in a database
# check if db_path is valid 
# have second argument for table path

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi
