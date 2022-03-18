#!/bin/bash
set -e

./backup.sh

## Mount GCS bucket and move artifacts
if [ "$DO_UPLOAD" -eq "1" ]; then
    ./gcs/upload.sh
else
    echo "Skip uploading..."
fi
