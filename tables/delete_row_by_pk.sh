#!/bin/bash

# Delete row(s) from a table by primary key
# Usage: . ./delete_row_by_pk.sh <db_path>

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
read -r -p "Enter Primary Key of the row to delete: " pk
if awk -F: -v id="$pk" '$1==id {found=1} END{exit !found}' "$data_file"; then
    sed -i "/^$pk:/d" "$data_file"
    echo "[OK] Row deleted"
else
    echo "[ERROR] PK not found"
fi