#!/bin/bash

set -e
gsutil cp -R /backups/output/ "s3://$STORAGE_BUCKET_NAME"
