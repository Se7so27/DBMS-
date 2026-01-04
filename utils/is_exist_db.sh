#!/bin/bash
# utils/is_exist_db.sh
# Purpose: Check whether a database exists under the provided db_path.
# Parameters:
#   $1 - db_path : path to the root of databases (DB_HOME)
#   $2 - db_name : name of database to check (case-insensitive; normalized to lowercase)

 db_path=$1
 db_name=${2,,}

 # If directory exists, return success (0); otherwise return non-zero
 if [[ -d "$db_path/$db_name" ]]; then
     echo "[INFO]: There is database with name $db_name"
     exit 0
 fi

 echo "[INFO]: No Database With Name $db_name"
 exit 1