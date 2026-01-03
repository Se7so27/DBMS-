#!/bin/bash
DB_HOME="$HOME/DATABASES"

DB_NAME="$1"
DB_PATH="$DB_HOME/$DB_NAME"

if [[ -z "$DB_NAME" || ! -d "$DB_PATH" ]]; then
    echo "[ERROR]: Database not provided or does not exist. Please connect to a database first."
    exit 1
fi


while true; do
    echo "============ MANIPULATING TABLES (Database: ${DB_NAME}) =============="

    echo "1. Create Table"
    echo "2. Drop Table"
    echo "3. List Tables"
    echo "4. Insert Row"
    echo "5. Select From Table"
    echo "6. Alter Table (rename)"
    echo "7. Add Column "
    echo "8. Back to Databases Menu"
    echo "9. Exit"
    cd  ../tables
    read -r -p "Choose : " choice
    case $choice in
        1)
            echo "[INFO]: Create Table"
            . ./create_table.sh "$DB_PATH"
            ;;
        2)
            echo "[INFO]: Drop Table"
            . ./drop_table.sh "$DB_PATH"
            ;;
        3)
            echo "[INFO]: List Tables"
            . ./list_tables.sh "$DB_PATH"
            ;;
        4)
            echo "[INFO]: Insert Row"
            . ./insert_row.sh "$DB_PATH"
            ;;
        5)
            echo "[INFO]: Select From Table"
            . ./select_table.sh "$DB_PATH"
            ;;
        6)
            echo "[INFO]: Alter Table"
            . ./alter_table.sh "$DB_PATH"
            ;;
            
        7)
            echo "[INFO]: Add Column"
            . ./add_column.sh "$DB_PATH"
            ;;
        8)
            echo "Returning to databases menu"
            ../dbs/main.sh
            break
            ;;
        9)
            echo "Exit"
            exit 0
            ;;
        *)
            echo "Please provide a valid answer"
            ;;
    esac
done
