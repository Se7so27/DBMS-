#!/bin/bash
# utils/valid_db_name.sh
# Purpose: Validate database/table name according to project rules.
# Rules enforced:
#  - non-empty
#  - no whitespace
#  - not only digits
#  - allowed characters: letters, numbers, underscore
#  - not a reserved keyword
#  - maximum length 62 characters

 db_name=$1
 db_name=${db_name,,}

 # empty ?
 if [[ -z "$db_name" ]]; then
     echo "[ERROR]: Table Name cannot be empty!"
     echo "[SOURCE]: $0 <Table_name>"
     exit 1
 fi

 # no spaces
 echo "$db_name"
 if [[ "$db_name" =~ [[:space:]] ]]; then
     echo "[ERROR]: Table Name cannot contain space!"
     echo "[SOURCE]: $0 <Table_name>"
     exit 1
 fi

# only numbers
if [[ "$db_name" =~ ^[0-9]+$ ]]; then
    echo "[ERROR]: Table Name cannot be only numbers"
    echo "[SOURCE]: $0 <Table_name>"
    exit 1
fi

# no special characters . / $ % ^ ....
if [[ ! "$db_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "[ERROR]: Table Name cannot contain special characters, Only A-z 0-9 _"
    echo "[SOURCE]: $0 <Table_name>"
    exit 1
fi

# no reserved keywords
if  grep -q "$db_name" -iw ../utils/db_reserved_keywords.txt; then
    echo "[ERROR]: Table name cannot be reserved keyword!"
    echo "[SOURCE]: $0 <Table_name>"
    exit 1
fi

# length <= 62
if [[ ${#db_name} -gt 62 ]]; then
    echo "[ERROR]: Table name cannot be more than 62 character"
    echo "[SOURCE]: $0 <Table_name>"
    exit 1
fi
