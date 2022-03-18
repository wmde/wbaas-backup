#!/bin/bash
set -e

## mount bucket
./gcs/mount_bucket.sh

## move backup artifacts into mounted bucket
mv /backups/* /mnt/backup-bucket/

## unmount bucket
./gcs/unmount_bucket.sh
