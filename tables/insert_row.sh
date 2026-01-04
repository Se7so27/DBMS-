#!/bin/bash

# tables/insert_row.sh
# Purpose: Insert a colon-separated row into a table's .data file. Validates
# that the number of fields matches the table's .meta file and enforces primary
# key constraints (non-empty and uniqueness) when defined.
# Parameters:
#   $1 - db_path : path to the database directory

# Note: Rows are stored colon-separated and column order must match .meta file

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name : " table_name
data_file="$db_path/${table_name,,}.data"
meta_file="$db_path/${table_name,,}.meta"

if [[ ! -f "$data_file" || ! -f "$meta_file" ]]; then
    echo "[ERROR]: Table '${table_name,,}' does not exist or missing metadata"
    return 1
fi

# expected fields = number of meta lines
expected=$(wc -l < "$meta_file" | tr -d ' ')
# find PK index (if any) and its name
pk_idx=$(awk -F: '$3=="PK" {print NR; exit}' "$meta_file")
pk_name=$(awk -F: '$3=="PK" {print $1; exit}' "$meta_file")

while true; do
    read -r -p "Enter row (colon-separated): " row

    # Build regex dynamically to ensure there are exactly 'expected' colon-separated fields
    regex="^[^:]+"
    for ((i=1; i<$expected; i++)); do
        regex+="(:[^:]+)"
    done
    regex+="$"

    # Validate basic format using the constructed regex
    if [[ ! "$row" =~ $regex ]]; then
        echo "[ERROR]: Invalid format. Expected $expected fields separated by single colons."
        continue
    fi

    # Split into fields safely
    IFS=':' read -ra fields <<< "$row"

    if [[ ${#fields[@]} -ne $expected ]]; then
        echo "[ERROR]: Expected $expected fields (based on table metadata). You provided ${#fields[@]}. Try again."
        continue
    fi

    # if PK present, validate non-empty and uniqueness
    if [[ -n "$pk_idx" ]]; then
        pk_value="${fields[$((pk_idx-1))]}"
        if [[ -z "$pk_value" ]]; then
            echo "[ERROR]: Primary key '${pk_name}' cannot be empty"
            continue
        fi
        # check for duplicate PK value using awk; returns success if found
        if awk -F: -v id="$pk_value" '$1==id {found=1} END{exit !found}' "$data_file"; then
            echo "[ERROR]: Duplicate primary key value '${pk_value}' for '${pk_name}'"
            continue
        fi
    fi

    # append row to data file
    echo "$row" >> "$data_file"
    echo "[INFO]: Row inserted into '${table_name,,}'"
    continue_prompt=""
    read -r -p "Insert another row? [y/N]: " continue_prompt
    if [[ ! "$continue_prompt" =~ ^[Yy]$ ]]; then
        break
    fi

done
# sort data file by PK (first column) if applicable to keep rows ordered
if [[ -n "$pk_idx" ]]; then
    sort -n -t: -k1,1 "$data_file" -o "$data_file"
fi

return 0
