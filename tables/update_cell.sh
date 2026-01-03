#!/bin/bash
db_path="$1"
table_name="$2"
pk="$3"
file="$db_path/${table_name}.data"
. ./record_of_pk.sh "$table_name" "$db_path"  "$pk"
read -p "Enter column number to update: " fild_no
col=$((fild_no))
read -p "Enter new value: " val
awk -F: -v OFS=: -v pk="$pk" -v col="$col" -v val="$val" '
{
    if ($1 == pk) $col = val
    print
}' "$file" > tmp && mv tmp "$file"