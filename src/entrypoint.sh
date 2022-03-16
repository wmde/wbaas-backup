#!/bin/bash

./backup.sh

## Mount GCS bucket and move artifacts
if [ "$DO_UPLOAD" -eq "1" ]; then
    ./upload.sh
else
    echo "Skip uploading..."
fi
