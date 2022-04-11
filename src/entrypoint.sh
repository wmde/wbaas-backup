#!/bin/bash
set -e

./backup.sh

## GCS bucket is mounted by chart
# We can just move the artifacts
if [ "$DO_UPLOAD" -eq "1" ]; then
    mv /backups/* /mnt/backup-bucket/
else
    echo "Skip uploading..."
fi
