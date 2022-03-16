#!/bin/bash
set -e

## mount bucket
gcsfuse --key-file=/var/run/secret/cloud.google.com/key.json "$GCS_BUCKET_NAME" /mnt/backup-bucket

## move backup artifacts into mounted bucket
mv /backups/* /mnt/backup-bucket/
ls /mnt/backup-bucket

## unmount bucket
fusermount -u /mnt/backup-bucket