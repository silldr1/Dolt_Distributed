#!/bin/sh
export PATH="/root/bin:$PATH"

set -e

NODE_NAME=$(hostname)

echo "[nodeX] Installing dependencies..."
apt-get update && apt-get install -y git

echo "[nodeX] Configuring Dolt identity..."
dolt config --global --add user.name "NodeX"
dolt config --global --add user.email "nodex@example.com"

echo "[nodeX] Waiting for node1 to finish push..."
until [ -f /dolt-remote/.node1_ready ]; do
  echo "[nodeX] Waiting for /dolt-remote/.node1_ready..."
  sleep 1
done

echo "[nodeX] Cloning from shared Dolt remote..."
cd /root
dolt clone file:///dolt-remote/main.git dolt

echo "[nodeX] Clone complete."

cd /root/dolt


# Loop: periodically export commit logs and schema
while true; do
  dolt log --json > /dolt-remote/${NODE_NAME}_log.json
  dolt schema show --json > /dolt-remote/${NODE_NAME}_schema.json
  sleep 10
done