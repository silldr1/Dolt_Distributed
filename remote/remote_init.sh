#!/bin/sh

# Optional: configure user identity
dolt config --global --add user.name "dolt-remote"
dolt config --global --add user.email "dolt-remote@localhost"


echo "Initializing Dolt repository..."
cd /root/dolt
dolt init
dolt sql < /db_init.sql
dolt add .
dolt commit -m "init database"
mkdir -p /dolt-remote/test-repo
dolt remote add origin file:///dolt-remote/test-repo
dolt push origin main


touch /dolt-remote/.ready

# Step 3: Start Dolt SQL server
exec dolt sql-server -H 0.0.0.0 --port 3306




