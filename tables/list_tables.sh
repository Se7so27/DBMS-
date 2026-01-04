#!/bin/bash
# tables/list_tables.sh
# Purpose: List all tables (.data files) within a database directory
# Parameters:
#   $1 - db_path : path to the database directory

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

# Use shell globbing to find .data files; suppress errors if none found
tables=$(ls -A "$db_path"/*.data 2>/dev/null)

if [[ -z "$tables" ]]; then
    echo "[LOG]: No tables"
else
    echo "Tables in database:"
    for table in "$db_path"/*.data; do
        name="$(basename "$table" .data)"
        echo "[-] $name"
    done
fi

return 0
