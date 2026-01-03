#!/bin/bash

# Usage: is_exist_table.sh <db_path> <table_name>
# Returns 0 if table exists (data or meta file present), 1 otherwise

db_path=$1
table_name=$2

if [[ -z "$db_path" || -z "$table_name" || ! -d "$db_path" ]]; then
    return 1
fi

if [[ -f "$db_path/${table_name,,}.data" || -f "$db_path/${table_name,,}.meta" || -f "$db_path/${table_name,,}" ]]; then
    echo "[INFO]: There is table with name $table_name"
    return 0
else
    echo "[INFO]: No Table With Name $table_name"
    return 1
fi
