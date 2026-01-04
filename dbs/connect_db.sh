#!/bin/bash
# dbs/connect_db.sh
# Purpose: Prompt the user to select an existing database to connect to and
#          launch the tables menu for that database.
# Parameters:
#   $1 - db_path : the root directory where databases are stored (DB_HOME)

db_path=$1

# Keep prompting until a valid database name is provided
while true; do
    read -r -p "Database To Connect : " db_name
    # Validate the name format and check existence using helper utils
    if ../utils/valid_db_name.sh "$db_name" && ../utils/is_exist_db.sh "$db_path" "$db_name"; then
        echo "[INFO]: Connecting Database $db_name"
        # If tables/main.sh returns success, bubble up 0 to caller
        if ../tables/main.sh "$db_name"; then
            echo "[INFO]: tables menu exited with 0 — returning to caller"
            return 0
        fi
    else
        # Inform the user and show available DBs so they can pick a valid one
        echo "[ERROR]: Database '$db_name' does not exist. Please enter a valid database name."
        ./list_db.sh "$db_path"
    fi
done
