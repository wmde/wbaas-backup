#!/bin/bash
set -e
set -o pipefail

INPUT_DIR=$1
OUTPUT_FILE=$2
tar -cz -C "$INPUT_DIR" . | openssl enc -pbkdf2 -pass "pass:$BACKUP_KEY" -e -aes256 -out "$OUTPUT_FILE"
