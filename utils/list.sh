#!/bin/bash
# utils/list.sh
# Purpose: Helper for listing resources under DB_HOME. Currently it validates
# that the provided db_path exists; can be extended to list tables for a
# particular database when a second argument (table path) is provided.
# Parameters:
#   $1 - db_path : path to DB_HOME or a database directory

db_path=$1

# Basic validation: ensure the provided path exists and is a directory
if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi
