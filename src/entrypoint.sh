#!/bin/bash
set -e

if [ "$DO_CHECK_SECONDARY" -eq "1" ]; then
    ./check_secondary_status.sh
else
    echo "Skip checking secondary..."
fi

./backup.sh

## GCS bucket is mounted by chart
# We can just move the artifacts
if [ "$DO_UPLOAD" -eq "1" ]; then
    mv /backups/* /mnt/backup-bucket/
else
    echo "Skip uploading..."
fi
