#!/bin/bash

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name to drop : " table_name
if [[ -f "$db_path/${table_name,,}.data" ]]; then
    read -r -p "Are you sure you want to drop '${table_name,,}'? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -f "$db_path/${table_name,,}.data"
        rm -f "$db_path/${table_name,,}.meta"
        echo "[INFO]: Table '${table_name,,}' dropped"
    else
        echo "[INFO]: Abort dropping table"
    fi
else
    echo "[ERROR]: Table '${table_name,,}' does not exist"
fi

return 0
