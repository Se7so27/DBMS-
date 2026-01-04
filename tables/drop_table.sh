#!/bin/bash
# tables/drop_table.sh
# Purpose: Remove a table's data and metadata files from a database
# Parameters:
#   $1 - db_path : path to the database directory
# Notes:
# - Confirms with the user before deletion to avoid accidental loss of data

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name to drop : " table_name
if ../utils/valid_table_name.sh "$table_name" ; then
    table_name="${table_name,,}"
else
    echo "[ERROR]: Invalid table name"
    exit 1
fi
if [[ -f "$db_path/${table_name,,}.data" ]]; then
    read -r -p "Are you sure you want to drop '${table_name,,}'? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Remove both data and meta files
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
