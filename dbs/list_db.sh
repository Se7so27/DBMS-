#!/bin/bash

db_path=$1
database=$(ls $db_path)
echo $1

if [[ -z "$database" ]]; then
    echo "[LOG]: No Databases"
    else
        for db in "$db_path"/* 
        do
            name="${db##*/}"
            echo "[-] ${name}"
        done
fi

./main.sh