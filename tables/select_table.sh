#!/bin/bash

# Show table metadata and data

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name : " table_name
data_file="$db_path/${table_name,,}.data"
meta_file="$db_path/${table_name,,}.meta"

if [[ ! -f "$data_file" || ! -f "$meta_file" ]]; then
    echo "[ERROR]: Table '${table_name,,}' does not exist or/or missing metadata"
    return 1
fi

echo "--- Schema: '${table_name,,}' ---"
nl -ba "$meta_file" | sed -E 's/:/\t/g'

echo "--- Data: '${table_name,,}' ---"
nl -ba "$data_file"

return 0
