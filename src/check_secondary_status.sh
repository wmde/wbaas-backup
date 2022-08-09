#!/bin/bash
set -e
set -o pipefail

SECONDS_BEHIND=$(mysql -e "show slave status\G" --host="$SECONDARY_HOST" --port="$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" | grep "Seconds_Behind_Master" | awk '{print $2}')
SECONDS_BEHIND=${SECONDS_BEHIND%.*}

if [[ $SECONDS_BEHIND = "NULL" ]]; then
    echo "Replication isn't running yet got NULL seconds behind primary!"
    exit 1;
elif [[ ${SECONDS_BEHIND} =~ ^-?[0-9]+$ && $REPLICATION_THRESHOLD -gt ${SECONDS_BEHIND} ]]; then
    exit 0;
else
    echo "More than $REPLICATION_THRESHOLD seconds behind primary"
    exit 1;
fi