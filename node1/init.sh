#!/bin/sh
set -e

dolt config --global --add user.name "$(hostname)"
dolt config --global --add user.email "$(hostname)@localhost"


echo "[node1] Configuring Dolt identity..."
dolt config --global --add user.name "Node1"
dolt config --global --add user.email "node1@example.com"

echo "[node1] Initializing Dolt repository..."
cd /root/dolt
dolt init
dolt sql -q "CREATE TABLE test (id INT PRIMARY KEY, name VARCHAR(100));"
dolt add .
dolt commit -m "Initial commit from node1"

echo "[node1] Preparing shared remote path at /dolt-remote/."
mkdir -p /dolt-remote/test-repo
dolt remote add origin file:///dolt-remote/test-repo

echo "[node1] Pushing to shared Dolt remote..."
dolt push origin main

echo "[node1] Push complete. Signaling readiness..."
touch /dolt-remote/.node1_ready
