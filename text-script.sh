#!/bin/sh

for run in {1..120}; do
    sh script.sh
    exit_code=$?
    if [ $exit_code -eq 111 ]; then
    exit 0
    elif [ $exit_code -ne 0 ]; then
    exit $exit_code
    fi
    sleep 10
done