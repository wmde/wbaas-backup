#!/bin/bash

#DB_USER=root
#DB_PASSWORD=
#DB_HOST=127.0.0.1
#DB_PORT=3306
TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
BACKUP_DIR=/tmp/backup-"$TIMESTAMP"/
BACKUP_ARCHIVE=/tmp/"mydumper-backup-$TIMESTAMP".tar.gz

rm -rf "$BACKUP_DIR"

mydumper --user="$DB_USER" \
         --port="$DB_PORT" \
         --host="$DB_HOST" \
         --password="$DB_PASSWORD" \
         --outputdir="$BACKUP_DIR"

tar -cjf "$BACKUP_ARCHIVE" -C "$BACKUP_DIR" .

cp "$BACKUP_ARCHIVE" /mnt/backup-bucket/