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
    echo "7. Delete Row by PK"
    echo "8. Update Cell by PK"
    echo "9. Back to Databases Menu"
    echo "10. Exit"
    cd  ../tables
    read -r -p "Choose : " choice
    clear
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
            echo "[INFO]: Delete Row by PK"
            . ./delete_row_by_pk.sh "$DB_PATH"
            ;;
        7)
            echo "[INFO]: Update Cell by PK"
            read -r -p "Table name : " table_name
            read -r -p "Primary Key of the row to update: " pk_value
            . ./update_cell.sh "$DB_PATH" "$table_name" "$pk_value"
            ;;

        8)
            echo "Returning to databases menu"
            cd ../dbs/
            . ./main.sh
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
