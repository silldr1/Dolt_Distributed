#!/bin/sh

# Optional: configure user identity
dolt config --global --add user.name "dolt-remote"
dolt config --global --add user.email "dolt-remote@localhost"


echo "[nodeX] Waiting for node1 to finish push..."
until [ -f /dolt-remote/.node1_ready ]; do
  echo "[nodeX] Waiting for /dolt-remote/.node1_ready..."
  sleep 5
done

touch /dolt-remote/.ready

cd /dolt-remote/test-repo

# Step 3: Start Dolt SQL server
dolt sql-server -H 0.0.0.0 --port 3306




