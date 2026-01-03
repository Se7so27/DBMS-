#!/bin/bash

# Show table metadata and data

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name : " table_name
data_file="$db_path/${table_name,,}.data"
meta_file="$db_path/${table_name,,}.meta"

if [[ ! -f "$data_file" || ! -f "$meta_file" ]]; then
    echo "[ERROR]: Table '${table_name,,}' does not exist or/or missing metadata"
    return 1
fi
# Prompt for number of records to display




# show schema
echo "--- Schema: '${table_name,,}' ---"
nl -ba "$meta_file" | sed -E 's/:/\t/g'

# Provide display options: by PK, head (first N), or tail (last N)
while true; do
    echo "Choose display mode:"
    echo "1) By PK"
    echo "2) Head (first N)"
    echo "3) Tail (last N)"
    read -r -p "Choose [1-3]: " opt
    case $opt in
        1)
            # delegate to helper script
            read -r -p "Enter Primary Key value: " pk_value
            . ./record_of_pk.sh "$table_name" "$db_path" $pk_value
            break
            ;;
        2)
            # ask and validate number (>0)
            while true; do
                read -r -p "Enter number of records to display (default 10): " n
                if [[ -z "$n" ]]; then
                    n=10
                    break
                fi
                if [[ "$n" =~ ^[0-9]+$ ]] && [[ "$n" -gt 0 ]]; then
                    break
                fi
                echo "[ERROR]: Please enter a positive integer greater than 0."
            done
            . ./top_n_records.sh "$n" "$table_name" "$db_path" head
            break
            ;;
        3)
            while true; do
                read -r -p "Enter number of records to display (default 10): " n
                if [[ -z "$n" ]]; then
                    n=10
                    break
                fi
                if [[ "$n" =~ ^[0-9]+$ ]] && [[ "$n" -gt 0 ]]; then
                    break
                fi
                echo "[ERROR]: Please enter a positive integer greater than 0."
            done
            . ./top_n_records.sh "$n" "$table_name" "$db_path" tail
            break
            ;;
        *)
            echo "Please provide a valid option (1-3)"
            ;;
    esac
done


return 0
