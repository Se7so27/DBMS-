#!/bin/bash

# Alter table: operate on <table>.meta (schema) and <table>.data (rows)

db_path=$1

if [[ -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Database path is invalid or not provided"
    return 1
fi

read -r -p "Table name to alter: " tbl
data_file="$db_path/${tbl,,}.data"
meta_file="$db_path/${tbl,,}.meta"

if [[ ! -f "$data_file" || ! -f "$meta_file" ]]; then
    echo "[ERROR]: Table '${tbl,,}' does not exist or missing metadata"
    return 1
fi

while true; do
    echo "--- Alter Table (${tbl,,}) ---"
    echo "1) Create/Set Schema (define columns)"
    echo "2) Add Column"
    echo "3) Remove Column"
    echo "4) Rename Table"
    echo "5) Back"
    read -r -p "Choose: " opt
    case $opt in
        1)
            read -r -p "Enter comma-separated column definitions (name:type,...), e.g. id:int,name:string: " header
            # validate and parse
            IFS=',' read -ra defs <<< "$header"
            ok=true
            for d in "${defs[@]}"; do
                name=$(echo "$d" | cut -d':' -f1)
                type=$(echo "$d" | cut -d':' -f2)
                ../utils/valid_db_name.sh "$name" || { ok=false; echo "Invalid column name: $name"; break; }
                type=${type,,}
                if [[ "$type" != "int" && "$type" != "string" ]]; then ok=false; echo "Invalid type: $type"; break; fi
            done
            if [[ "$ok" = true ]]; then
                # backup
                cp "$meta_file" "$meta_file.bak.$(date +%s)"
                cp "$data_file" "$data_file.bak.$(date +%s)"
                # check existing data
                if [[ -s "$data_file" ]]; then
                    read -r -p "Table has data — setting schema may require clearing data. Clear data file? [y/N] " conf
                    if [[ "$conf" =~ ^[Yy]$ ]]; then
                        : > "$data_file"
                    else
                        echo "Note: existing data preserved; schema and existing rows may be incompatible"
                    fi
                fi
                # write meta lines
                : > "$meta_file"
                for d in "${defs[@]}"; do
                    echo "$d" >> "$meta_file"
                done
                echo "[INFO]: Schema set"
            fi
            ;;
        2)
            # add column to meta and append empty field to data rows
            read -r -p "Column name to add: " col
            ../utils/valid_db_name.sh "$col" || { echo "Invalid column name"; continue; }
            read -r -p "Column data type (int/string): " ctype
            ctype=${ctype,,}
            if [[ "$ctype" != "int" && "$ctype" != "string" ]]; then echo "Invalid type"; continue; fi
            # check PK presence
            if grep -q ":PK\$" "$meta_file"; then
                read -r -p "Make this column PK? [y/N]: " pkc
                if [[ "$pkc" =~ ^[Yy]$ ]]; then
                    echo "[ERROR]: PK already chosen for this table"; continue
                fi
            else
                read -r -p "Make this column PK? [y/N]: " pkc
                if [[ "$pkc" =~ ^[Yy]$ ]]; then
                    echo "$col:$ctype:PK" >> "$meta_file"
                else
                    echo "$col:$ctype" >> "$meta_file"
                fi
            fi
            # backup and append empty field to data
            cp "$data_file" "$data_file.bak.$(date +%s)"
            awk 'BEGIN{FS=OFS=","} {print $0 OFS ""}' "$data_file" > "$data_file.tmp" && mv "$data_file.tmp" "$data_file"
            echo "[INFO]: Column '$col' added"
            ;;
        3)
            # show header
            echo "Current schema (line#: name:type[:PK]):"
            nl -ba "$meta_file"
            read -r -p "Enter column number or name to remove: " key
            idx=""
            if [[ "$key" =~ ^[0-9]+$ ]]; then
                idx=$key
            else
                idx=$(nl -ba "$meta_file" | awk -v name="$key" '{split($0,a,"\t"); if(a[2] ~ "^" name ":") print $1}')
            fi
            if [[ -z "$idx" ]]; then
                echo "[ERROR]: Column not found"
                continue
            fi
            # backup
            cp "$meta_file" "$meta_file.bak.$(date +%s)"
            cp "$data_file" "$data_file.bak.$(date +%s)"
            # remove nth line from meta
            awk -v rem=$idx 'NR!=rem' "$meta_file" > "$meta_file.tmp" && mv "$meta_file.tmp" "$meta_file"
            # remove nth field from data rows
            awk -v rem=$idx 'BEGIN{FS=OFS=","} {out=""; for(i=1;i<=NF;i++) if(i!=rem) out = (out==""? $i : out OFS $i); print out}' "$data_file" > "$data_file.tmp" && mv "$data_file.tmp" "$data_file"
            echo "[INFO]: Column #$idx removed"
            ;;
        4)
            read -r -p "New table name : " newname
            ../utils/valid_db_name.sh "$newname" || { echo "Invalid new table name"; continue; }
            if ../utils/is_exist_table.sh "$db_path" "$newname"; then
                echo "[ERROR]: A table with name '${newname,,}' already exists"
                continue
            fi
            # backup
            cp "$meta_file" "$meta_file.bak.$(date +%s)"
            cp "$data_file" "$data_file.bak.$(date +%s)"
            mv "$meta_file" "$db_path/${newname,,}.meta"
            mv "$data_file" "$db_path/${newname,,}.data"
            echo "[INFO]: Table '${tbl,,}' renamed to '${newname,,}'"
            # update tbl and file paths
            tbl="$newname"
            data_file="$db_path/${tbl,,}.data"
            meta_file="$db_path/${tbl,,}.meta"
            ;;
        5)
            break
            ;;
        *)
            echo "Please provide a valid answer"
            ;;
    esac
done

return 0
