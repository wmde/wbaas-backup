#!/bin/bash
set -e

gcsfuse --key-file=/var/run/secret/cloud.google.com/key.json "$GCS_BUCKET_NAME" /mnt/backup-bucket