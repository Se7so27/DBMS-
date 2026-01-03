#!/bin/bash
# Usage: ./top_n_records.sh <records> <table_name> <db_path> [head|tail]
records=$1
table_name=$2
db_path=$3
mode=${4:-head}

if [[ -z "$table_name" || -z "$db_path" || ! -d "$db_path" ]]; then
    echo "[ERROR]: Usage: $0 <records> <table_name> <db_path> [head|tail]" >&2
    exit 1
fi

data_file="$db_path/${table_name,,}.data"
if [[ ! -f "$data_file" ]]; then
    echo "[ERROR]: Table '${table_name,,}' does not exist or has no data" >&2
    exit 1
fi

max_count=$(wc -l < "$data_file" | tr -d ' ')
if [[ "$max_count" -eq 0 ]]; then
    echo "[LOG]: No data"
    exit 0
fi

if ! [[ "$records" =~ ^[0-9]+$ ]] || [[ "$records" -lt 1 ]]; then
    records="$max_count"
fi

if [[ "$mode" == "head" ]]; then
    nl -ba "$data_file" | head -n "$records"
else
    nl -ba "$data_file" | tail -n "$records"
fi
