#!/bin/bash
# dbs/main.sh - Database menu entrypoint
# Purpose:
# - Define the root folder for databases (DB_HOME)
# - Ensure the directory exists
# - Present a small menu for database-level operations and dispatch the user's choice
# Usage: Run this script to manage databases interactively (connect/create/drop/list)

DB_HOME="$HOME/DATABASES"

# Ensure the root directory for databases exists (creates it if needed)
mkdir -p "$DB_HOME"

# show database menu
echo "WELCOME TO DBMS"
echo "==============="
echo "1. Connect To Database"
echo "2. Create Database"
echo "3. Drop Database"
echo "4. List Databases"
echo "5. Exit"


while true; do
    read -p "Choose : " choice
    case $choice in
        1)
            echo "[INFO]: Let's connect database"
            . ./connect_db.sh "$DB_HOME"
            break;
            ;;
        2)
            echo "[INFO]: Let's create database";
            . ./create_db.sh "$DB_HOME";
            break;
            ;;
        3)
            echo "[INFO]: Let's drop database";
            . ./drop_db.sh "$DB_HOME";
            break;
            ;;
        4)
            echo "[INFO]: Let's list database";
            . ./list_db.sh "$DB_HOME";
            break;
            ;;
        5)
            echo "Exit"
            exit 0
            break;
            ;;
        *)

            echo "Please provide valid answer"
            ;;

    esac
done

