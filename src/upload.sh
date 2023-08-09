#!/bin/bash

set -e
mc alias set remote "$STORAGE_ENDPOINT" "$STORAGE_ACCESS_KEY" "$STORAGE_SECRET_KEY" --api "$STORAGE_SIGNATURE_VERSION"
mc cp --recursive /backups/output remote/"$STORAGE_BUCKET_NAME"
