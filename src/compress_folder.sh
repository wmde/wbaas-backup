#!/bin/bash
set -e

tar -czf - ./* | openssl enc -pbkdf2 -pass "pass:$BACKUP_KEY" -e -aes256 -out "$1"