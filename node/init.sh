#!/bin/bash

dolt config --global --add user.name "Test"
dolt config --global --add user.email "test@example.com"


cd /root/dolt

# Check if this is the first time setup
if [ ! -d .dolt ]; then
    dolt init
    dolt sql -q "CREATE TABLE test (id INT PRIMARY KEY, name VARCHAR(100));"
    dolt add .
    dolt commit -m "Initial commit"

    dolt remote add origin $DOLT_REMOTE_URL
    dolt creds init
    dolt push origin main
else
    dolt remote add origin $DOLT_REMOTE_URL || true
    dolt pull origin main || true
fi
