#!/bin/bash

# tables/record_of_pk.sh
# Purpose: Given a table name, db path and primary key value, find and print
# the matching record (line) from the table's .data file.
# Parameters:
#   $1 - table_name
#   $2 - db_path
#   $3 - pk_value

table_name=$1
db_path=$2
pk_value=$3

# Identify PK column name and its column number (line number in the meta file)
pk_column=$(awk -F : '{if ($3 == "PK") {print $1}}' "${db_path}/${table_name}.meta");
pk_column_no=$(awk -F : '{if ($3 == "PK") {print NR}}' "${db_path}/${table_name}.meta");

# Search the data file by comparing the field at pk_column_no to pk_value
record=$(awk -v pkn="$pk_column_no" -v pkv="$pk_value" -F : '{if ($pkn == pkv) {print $0}}' "$db_path/$table_name.data")

if [[ -z "$record" ]]; then
    echo "No ${pk_column} with value ${pk_value}"
else
    echo "$record"
fi
