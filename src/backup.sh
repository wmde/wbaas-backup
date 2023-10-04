#!/bin/bash
set -e

mkdir -p /backups/tmp
mkdir -p /backups/output

ROOT=$PWD
TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
BACKUP_DIR=/backups/tmp/backup-"$TIMESTAMP"
BACKUP_ARCHIVE=/backups/output/mydumper-backup.tar.gz

mydumper --user="$DB_USER" \
         --port="$DB_PORT" \
         --host="$DB_HOST" \
         --password="$DB_PASSWORD" \
         --outputdir="$BACKUP_DIR" \
         --trx-consistency-only \
         --verbose="$MYDUMPER_VERBOSE_LEVEL"

bash "$ROOT/validate_expected_files.sh" "$BACKUP_DIR"

bash "$ROOT/compress_folder.sh" "$BACKUP_DIR" "$BACKUP_ARCHIVE"
