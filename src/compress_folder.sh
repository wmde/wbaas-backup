#!/bin/bash
set -ex

tar -czf - * | openssl enc -pbkdf2 -pass "pass:$BACKUP_KEY" -e -aes256 -out "$1"