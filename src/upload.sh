#!/bin/bash

set -e
AWS_ACCESS_KEY_ID=$STORAGE_ACCESS_KEY \
    AWS_SECRET_ACCESS_KEY=$STORAGE_SECRET_KEY \
    AWS_DEFAULT_REGION=us-east-1 \
    aws s3 cp --recursive --endpoint "$STORAGE_ENDPOINT" /backups/output/ "s3://$STORAGE_BUCKET_NAME"
