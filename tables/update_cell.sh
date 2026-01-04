#!/bin/bash
# tables/update_cell.sh
# Purpose: Update a single field in a row identified by primary key.
# Parameters:
#   $1 - db_path
#   $2 - table_name
#   $3 - pk (primary key value)
# Notes:
# - Column number corresponds to the nth column in the table (1-based)
# - The script shows the matching record (via record_of_pk.sh) before asking input

 db_path="$1"
 table_name="$2"
 pk="$3"
 file="$db_path/${table_name}.data"
 # Display the existing record to the user
 . ./record_of_pk.sh "$table_name" "$db_path"  "$pk"
 read -p "Enter column number to update: " fild_no
 col=$((fild_no))
 read -p "Enter new value: " val
 # Use awk to update the requested column on the row where the first field equals pk
 awk -F: -v OFS=: -v pk="$pk" -v col="$col" -v val="$val" '
 {
     if ($1 == pk) $col = val
     print
 }' "$file" > tmp && mv tmp "$file"