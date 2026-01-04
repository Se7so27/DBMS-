#!/bin/bash

# Insert row into table (.data) - validates field count against meta

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name : " table_name
if ../utils/valid_table_name.sh "$table_name" ; then
    table_name="${table_name,,}"
else
    echo "[ERROR]: Invalid table name"
    exit 1
fi
data_file="$db_path/${table_name,,}.data"
meta_file="$db_path/${table_name,,}.meta"

if [[ ! -f "$data_file" || ! -f "$meta_file" ]]; then
    echo "[ERROR]: Table '${table_name,,}' does not exist or missing metadata"
    return 1
fi

# expected fields = number of meta lines
expected=$(wc -l < "$meta_file" | tr -d ' ')
# find PK index (if any)
pk_idx=$(awk -F: '$3=="PK" {print NR; exit}' "$meta_file")
pk_name=$(awk -F: '$3=="PK" {print $1; exit}' "$meta_file")


while true; do
    read -r -p "Enter row (colon-separated): " row

    # Build regex dynamically
    regex="^[^:,\ ]+"
    for ((i=1; i<$expected; i++)); do
        regex+="(:[^:,\ ]+)"
    done
    regex+="$"

    # Validate
    if [[ ! "$row" =~ $regex ]]; then
        echo "[ERROR]: Invalid format. Expected $expected fields separated by single colons."
        echo "Example: val1:val2:...:val $expected"
        echo "Note: Field values cannot contain colons, commas, or spaces."
        cat "$meta_file" | nl -ba | awk -F: '{print "  Field " $1 ": " $2}'
        continue
    fi

# Safe to split
IFS=':' read -ra fields <<< "$row"

    if [[ ${#fields[@]} -ne $expected ]]; then
        echo "[ERROR]: Expected $expected fields (based on table metadata). You provided ${#fields[@]}. Try again."
        continue
    fi
    #check data type of each field
    valid=true
    for ((i=0; i<expected; i++)); do
        col_type=$(awk -F: "NR==$((i+1)) {print \$2}" "$meta_file")
        field_value="${fields[$i]}"
        if [[ "$col_type" == "int" ]]; then
            if ! [[ "$field_value" =~ ^-?[0-9]+$ ]]; then
                echo "[ERROR]: Field $((i+1)) ('$field_value') should be of type 'int'."
                valid=false
                break
            fi
        fi
        # for string, no specific check needed as all input is string by default
    done
    if [[ "$valid" == "false" ]]; then
        continue
    fi  
    pk_column_no=$(awk -F : '{if ($3 == "PK") {print NR}}' "${db_path}/${table_name}.meta");
    # if PK present, validate non-empty and uniqueness
    if [[ -n "$pk_idx" ]]; then
        pk_value="${fields[$((pk_idx-1))]}"
        if [[ -z "$pk_value" ]]; then
            echo "[ERROR]: Primary key '${pk_name}' cannot be empty"
            continue
        fi
        # check for duplicate PK value using awk; returns success if found
        if awk -F: -v id="$pk_value" -v pkn="$pk_column_no" '$pkn==id {found=1} END{exit !found}' "$data_file"; then
            echo "[ERROR]: Duplicate primary key value '${pk_value}' for '${pk_name}'"
            continue
        fi
    fi


    # append row
    echo "$row" >> "$data_file"
    echo "[INFO]: Row inserted into '${table_name,,}'"
    continue_prompt=""
    read -r -p "Insert another row? [y/N]: " continue_prompt
    if [[ ! "$continue_prompt" =~ ^[Yy]$ ]]; then
        break
    fi
    
done
# sort data file by PK if applicable
if [[ -n "$pk_idx" ]]; then
    sort -n -t: -k1,1 "$data_file" -o "$data_file"
fi

return 0
