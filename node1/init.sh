#!/bin/sh
export PATH="/root/bin:$PATH"

set -e

echo "[node1] Installing dependencies..."
apt-get update && apt-get install -y git

echo "[node1] Configuring Dolt identity..."
dolt config --global --add user.name "Node1"
dolt config --global --add user.email "node1@example.com"

echo "[node1] Initializing Dolt repository..."
cd /root/dolt
dolt init
dolt sql -q "CREATE TABLE test (id INT PRIMARY KEY, name VARCHAR(100));"
dolt add .
dolt commit -m "Initial commit from node1"

echo "[node1] Preparing shared remote path at /dolt-remote/main.git..."
mkdir -p /dolt-remote/main.git
dolt remote add origin file:///dolt-remote/main.git

echo "[node1] Pushing to shared Dolt remote..."
dolt push origin main

echo "[node1] Push complete. Signaling readiness..."
touch /dolt-remote/.node1_ready

cd /root/dolt

# while true; do
#   dolt log --json > /dolt-remote/node1_log.json
#   dolt schema show --json > /dolt-remote/node1_schema.json
#   sleep 10
# done