#!/bin/bash
set -eu

envsubst < ~/.boto.template > ~/.boto
