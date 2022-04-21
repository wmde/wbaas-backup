#!/bin/bash
set -e

BACKUP_ROOT=$1
FINAL_EXPECTED_FILES=()
DEFAULT_EXPECTED_FILES=( \
		"metadata" \
        "apidb.users.sql" \
        "apidb.users-schema.sql" \
        "apidb.wikis.sql" \
        "apidb.wikis-schema.sql" \
        "mysql.db.sql" \
        "mysql.db-schema.sql"
		)

# allow overriding expected files
if [[ -z "${EXPECTED_FILES// }" ]]; then
    FINAL_EXPECTED_FILES=("${DEFAULT_EXPECTED_FILES[@]}") 
else
    IFS=', ' read -r -a FINAL_EXPECTED_FILES <<< "$EXPECTED_FILES"
fi

for EXPECTED in "${FINAL_EXPECTED_FILES[@]}"; do
    FILE="$BACKUP_ROOT/$EXPECTED"
    if [[ -f "$FILE" && -s "$FILE" ]]; then
        echo "$FILE exists!"
    else
        echo "$FILE does not exist or is empty!"
        exit 1
    fi
done