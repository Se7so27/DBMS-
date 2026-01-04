#!/bin/bash
# dbs/create_db.sh
# Purpose: Interactively create a new database directory inside DB_HOME.
# Parameters:
#   $1 - db_path : the path to the root of databases (DB_HOME)
# Behavior:
# - Prompts until the user provides a valid name (using utils/valid_db_name.sh)
# - Ensures the name does not already exist (using utils/is_exist_db.sh)
# - Creates the directory (lowercased) and returns to the DB menu

 db_path=$1

 # Read db name from user and validate it
 while true; do
     read -r -p "Database name : " db_name
     # Ensure the name is valid and does not already exist
    . ../utils/valid_db_name.sh "$db_name" && !(. ../utils/is_exist_db.sh "$db_path" "$db_name") && break
 done

 # Create folder in DB_HOME/name (lowercase to keep naming consistent)
 echo "[INFO]: This is a valid name, and no database with this name"
 mkdir -p "$db_path/${db_name,,}"

 # Return to databases menu
. ./main.sh