#!/bin/bash
# tables/main.sh
# Purpose: Manage tables within a connected database. This script expects a
# database name as the first parameter and then presents an interactive
# menu for table operations (create/drop/list/insert/select/alter/delete/update).
# Parameters:
#   $1 - DB_NAME : the name of the database to operate on (must exist under DB_HOME)
# Notes:
# - DB_HOME is set to $HOME/DATABASES by convention
# - The script delegates work to per-table scripts inside the 'tables' folder

DB_HOME="$HOME/DATABASES"

DB_NAME="$1"
DB_PATH="$DB_HOME/$DB_NAME"

# Validate that a database name was provided and exists
if [[ -z "$DB_NAME" || ! -d "$DB_PATH" ]]; then
    echo "[ERROR]: Database not provided or does not exist. Please connect to a database first."
    exit 1
fi

# Main interactive loop: show menu and dispatch to helper scripts in tables/
while true; do
    echo "============ MANIPULATING TABLES (Database: ${DB_NAME}) =============="

    echo "1. Create Table"
    echo "2. Drop Table"
    echo "3. List Tables"
    echo "4. Insert Row"
    echo "5. Select From Table"
    echo "6. Delete Row by PK"
    echo "7. Update Cell by PK"
    echo "8. Back to Databases Menu"
    echo "9. Exit"

    # Move into the tables directory where helper scripts are located
    cd  ../tables
    read -r -p "Choose : " choice
    clear
    case $choice in
        1)
            echo "[INFO]: Create Table"
            ./create_table.sh "$DB_PATH"
            ;;
        2)
            echo "[INFO]: Drop Table"
            ./drop_table.sh "$DB_PATH"
            ;;
        3)
            echo "[INFO]: List Tables"
            ./list_tables.sh "$DB_PATH"
            ;;
        4)
            echo "[INFO]: Insert Row"
            ./insert_row.sh "$DB_PATH"
            ;;
        5)
            echo "[INFO]: Select From Table"
            ./select_table.sh "$DB_PATH"
            ;;
        6)
            echo "[INFO]: Delete Row by PK"
            ./delete_row_by_pk.sh "$DB_PATH"
            ;;
        7)
            echo "[INFO]: Update Cell by PK"
            
            ./update_cell.sh "$DB_PATH" 
            ;;

        8)
            echo "Returning to databases menu"
            cd ../dbs/
            ./main.sh
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
