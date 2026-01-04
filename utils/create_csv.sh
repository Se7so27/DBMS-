#!/bin/bash
# utils/create_csv.sh
# Purpose: Create a CSV file from a table's data.
# Parameters:
#   $1 - db_path : path to the database directory
#   $2 - table_name : name of the table to export
#   $3 - csv_file : name of the CSV file to create

db_path="$1"
table_name="$2"
csv_file="$3"
mkdir ${HOME}/Documents/DBMS


data_file="$db_path/${table_name,,}.data"
meta_file="$db_path/${table_name,,}.meta"

if [[ ! -f "$data_file" && ! -f "$meta_file" ]]; then
    echo "[ERROR]: Table '${table_name,,}' does not exist or has no data"
    exit 1
fi
csv_path="${HOME}/Documents/DBMS/${csv_file}.csv"
touch "$csv_path"

# Create CSV header from meta file
header=$(awk -F: '{printf "%s,", $1}' "$meta_file" | sed 's/,$//')
echo "$header" > "$csv_path"
# Append data rows to CSV file
awk -F: '{
    for (i=1; i<=NF; i++) {
        printf "%s", $i
        if (i<NF) {
            printf ","
        }
    }
    printf "\n"
}' "$data_file" >> "$csv_path"
echo "[INFO] CSV file created at: $csv_path"
exit 0