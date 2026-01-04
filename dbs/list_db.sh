#!/bin/bash
# dbs/list_db.sh
# Purpose: List all databases (directories) under DB_HOME and return to the DB menu
# Parameters:
#   $1 - db_path : the path to the root of databases (DB_HOME)

db_path=$1
# Use ls safely and suppress errors if the directory is empty
database=$(ls "$db_path" 2>/dev/null)

echo "$1"

if [[ -z "$database" ]]; then
    echo "[LOG]: No Databases"
else
    for db in "$db_path"/* 
    do
        name="${db##*/}"
        echo "[-] ${name}"
    done
fi

# Return to the database menu
./main.sh