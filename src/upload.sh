#!/bin/bash

set -e
mc config host add "$STORAGE_ENDPOINT" "$STORAGE_HMAC_KEY" "$STORAGE_HMAC_SECRET" "$STORAGE_SIGNATURE_VERSION"
mc config add alias remote "$STORAGE_ENDPOINT"
mc cp /backups/output remote/"$STORAGE_BUCKET_NAME"
