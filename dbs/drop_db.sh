#!/bin/bash
# dbs/drop_db.sh
# Purpose: Prompt for a database name and delete that database directory.
# Parameters:
#   $1 - db_path : the root directory where databases are stored (DB_HOME)
# Notes:
# - Validates the name and existence with helper scripts before deletion
# - Uses 'rm -r' to remove the directory and its contents (be careful)

db_path=$1

# Prompt until a valid existing database name is provided, then remove it
while true; do
    read -r -p "Database name to drop : " db_name
    if ../utils/valid_db_name.sh "$db_name" && ../utils/is_exist_db.sh "$db_path" "$db_name"; then
        # Confirmed valid and exists, perform removal
        echo "[INFO] Dropping Database ($db_name) .... "
        rm -r "$db_path/$db_name"
        break
    fi
done

# Return to databases menu
./main.sh
