#!/bin/bash

db_path=$1

# read database name from user

while true; do
    read -r -p "Database To Connect : " db_name
    if ../utils/valid_db_name.sh "$db_name" && ../utils/is_exist_db.sh "$db_path" "$db_name"; then
        echo "[INFO]: Connecting Database $db_name"
        if ../tables/main.sh "$db_name"; then
            echo "[INFO]: tables menu exited with 0 — returning to caller"
            return 0
        fi
    else
        echo "[ERROR]: Database '$db_name' does not exist. Please enter a valid database name."
        ./list_db.sh "$db_path"
    fi
done
# validate, that it is a valid database
# validate it is exist 
# move to main.sh of tables
