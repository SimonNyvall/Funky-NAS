#!/bin/bash

DB_FILE="file.db"

SQL_FILE="create_tables.sql"

if [ ! -f "$SQL_FILE" ]; then
    echo "SQL file not found: $SQL_FILE"
    exit 1
fi

sqlite3 $DB_FILE < $SQL_FILE

echo "Database created and tables added successfully."
