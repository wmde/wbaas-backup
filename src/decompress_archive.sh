#!/bin/bash
set -e
set -o pipefail

# example: BACKUP_KEY=asdf ./decompress_archive.sh /backups/mydumper-backup-2022-03-18_122503.tar.gz /tmp/outdir
mkdir -p "$2"
openssl enc -pass "pass:$BACKUP_KEY" -pbkdf2 -d -aes256 -in "$1" | tar xz -C "$2"