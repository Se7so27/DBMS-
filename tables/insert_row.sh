#!/bin/bash

# Insert row into table (.data) - validates field count against meta

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name : " table_name
data_file="$db_path/${table_name,,}.data"
meta_file="$db_path/${table_name,,}.meta"

if [[ ! -f "$data_file" || ! -f "$meta_file" ]]; then
    echo "[ERROR]: Table '${table_name,,}' does not exist or missing metadata"
    return 1
fi

# expected fields = number of meta lines
expected=$(wc -l < "$meta_file" | tr -d ' ')

while true; do
    read -r -p "Enter row (comma-separated): " row
    IFS=',' read -ra fields <<< "$row"
    if [[ ${#fields[@]} -ne $expected ]]; then
        echo "[ERROR]: Expected $expected fields (based on table metadata). You provided ${#fields[@]}. Try again."
        continue
    fi
    # append row
    echo "$row" >> "$data_file"
    echo "[INFO]: Row inserted into '${table_name,,}'"
    break
done

return 0
