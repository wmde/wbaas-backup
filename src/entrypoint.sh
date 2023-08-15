#!/bin/bash
set -e

if [ "$DO_CHECK_SECONDARY" -eq "1" ]; then
    ./check_secondary_status.sh
else
    echo "Skip checking secondary..."
fi

./backup.sh

# We can just move the artifacts
if [ "$DO_UPLOAD" -eq "1" ]; then
    ./configure_gsutil.sh
    ./upload.sh
else
    echo "Skipping upload as DO_UPLOAD is not set..."
fi

TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
echo "Finished dump at: $TIMESTAMP"

./cleanup.sh
