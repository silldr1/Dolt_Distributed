#!/bin/bash

cd /root/dolt

# Check if this is the first time setup
if [ ! -d .dolt ]; then
    dolt init
    dolt sql -q "CREATE TABLE test (id INT PRIMARY KEY, name VARCHAR(100));"
    dolt add .
    dolt commit -m "Initial commit"

    dolt remote add origin $DOLT_REMOTE_URL
    dolt creds import --name default --public-key ~/.dolt_id.pub --private-key ~/.dolt_id
    dolt push origin main
else
    dolt remote add origin $DOLT_REMOTE_URL || true
    dolt pull origin main || true
fi
