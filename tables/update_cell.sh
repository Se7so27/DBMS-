#!/bin/bash
db_path="$1"


read -r -p "Table name : " table_name
if ../utils/valid_table_name.sh "$table_name" ; then
    table_name="${table_name,,}"
else
    echo "[ERROR]: Invalid table name"
    exit 1
fi

file="$db_path/${table_name}.data"
if [[ ! -f "$file" ]]; then
    echo "[ERROR]: Table '${table_name}' does not exist or has no data" >&2
    exit 1
fi
read -r -p "Primary Key of the row to update: " pk_value
meta_file="$db_path/${table_name}.meta"
pk_column_no=$(awk -F : '{if ($3 == "PK") {print NR}}' "${db_path}/${table_name}.meta");
echo "PK column is in field : ${pk_column_no}"
# get the row
record=$(./record_of_pk.sh "$table_name" "$db_path" "$pk_value")

read -p "Enter column number to update: " fild_no
col=$((fild_no))
if [[ $col -eq $pk_column_no ]]; then
    echo "[ERROR]: Cannot update Primary Key field."
    exit 1
fi
if [[ $col -lt 1 ]]; then
    echo "[ERROR]: Invalid column number."
    exit 1
fi
IFS=':' read -ra fields <<< "$record"
read -p "Enter new value: " val
valid=true

col_type=$(awk -F: "NR==$((fild_no)) {print \$2}" "$meta_file")
field_value="${fields[$((col-1))]}"
if [[ "$col_type" == "int" ]]; then
    if ! [[ "$field_value" =~ ^-?[0-9]+$ ]]; then
        echo "[ERROR]: Field $((i+1)) ('$field_value') should be of type 'int'."  
        valid=false
    fi    
fi
if [[ "$valid" == "true" ]]; then
awk -F: -v OFS=: -v pk="$pk_value" -v pkn="$pk_column_no" -v col="$col" -v val="$val" -v valid="$valid" '
    {
    if ($pkn == pk ) $col = val
        print
    }' "$file" > tmp && mv tmp "$file"
fi
