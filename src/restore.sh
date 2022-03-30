#!/bin/bash
set -e

BACKUP_RESTORE_DIR=$1

myloader --user="$DB_USER" \
         --port="$DB_PORT" \
         --host="$DB_HOST" \
         --password="$DB_PASSWORD" \
         --directory="$BACKUP_RESTORE_DIR" \
         --verbose="$MYDUMPER_VERBOSE_LEVEL"
