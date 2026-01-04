#!/bin/bash
# tables/create_table.sh
# Purpose: Interactively create a new table inside the provided database directory.
# Files created:
#  - <table>.data  : stores colon-separated rows (data)
#  - <table>.meta  : stores column definitions, one per line in the format:
#                   <column_name>:<type>[:PK]
#                   where type is 'int' or 'string', and ':PK' marks the primary key
# Usage: ./create_table.sh <db_path>

# Path to the database directory (where .data/.meta files are stored)
dp_path=$1

if [[ -z "$dp_path" || ! -d "$dp_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

# Read and validate table name
while true; do
    read -r -p "table name : " tb_name
    ../utils/valid_db_name.sh "$tb_name" || { echo "Please provide a valid table name"; continue; }
    if ../utils/is_exist_table.sh "$dp_path" "$tb_name"; then
        echo "[ERROR]: Table '$tb_name' already exists"
        continue
    fi
    break
done

# Build .data and .meta file paths (normalize to lowercase)
data_file="$dp_path/${tb_name,,}.data"
meta_file="$dp_path/${tb_name,,}.meta"

# create empty files
touch "$data_file" "$meta_file"

flag_pk_chosen=false
cols_count=0

echo "Define columns for table '$tb_name'. Enter -1 as column name when finished."
while true; do
    read -r -p "Enter column name (or -1 to finish): " col_name
    if [[ "$col_name" == "-1" ]]; then
        break
    fi
    # validate column name
    ../utils/valid_db_name.sh "$col_name" || { echo "Invalid column name: $col_name"; continue; }
    # ensure the same column has not already been defined in the meta file
    if grep -q "^$col_name:" "$meta_file"; then
        echo "Column '$col_name' already defined"
        continue
    fi

    # Read and validate column type
    read -r -p "Column data type (int/string): " col_type
    col_type=${col_type,,}
    if [[ "$col_type" != "int" && "$col_type" != "string" ]]; then
        echo "Invalid type. Supported types: int, string"
        continue
    fi

    # Optionally designate the first chosen column as the primary key (PK)
    if [[ "$flag_pk_chosen" == "false" ]]; then
        read -r -p "Do you want this column to be (PK) [y/N]: " pk_choice
        if [[ "$pk_choice" =~ ^[Yy]$ ]]; then
            echo "$col_name:$col_type:PK" >> "$meta_file"
            flag_pk_chosen=true
            cols_count=$((cols_count+1))
            continue
        fi
    fi

    echo "$col_name:$col_type" >> "$meta_file"
    cols_count=$((cols_count+1))
done

# If no columns were defined, remove created files and abort
if [[ $cols_count -eq 0 ]]; then
    rm -f "$data_file" "$meta_file"
    echo "[ERROR]: No columns defined. Table creation aborted."
    return 1
fi

echo "[INFO]: Table '${tb_name,,}' created with $cols_count columns"
return 0
