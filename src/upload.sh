#!/bin/bash

gcsfuse --key-file=/var/run/secret/cloud.google.com/key.json wikibase-dev-sql-backup /mnt/backup-bucket 

echo "UPLOADING!"

## Copy file into mounted bucket

ls /backups/
cp /backups/* /mnt/backup-bucket/
ls /mnt/backup-bucket