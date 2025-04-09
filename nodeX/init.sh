#!/bin/sh
set -e


echo "Configuring Dolt identity..."
dolt config --global --add user.name "NodeX"
dolt config --global --add user.email "nodex@example.com"

echo "Waiting for node1 to finish push..."
until [ -f /dolt-remote/.node1_ready ]; do
  echo "Waiting for /dolt-remote/.node1_ready..."
  sleep 5
done

echo "Cloning from shared Dolt remote..."
cd /root
dolt clone file:///dolt-remote/test-repo dolt

echo "Clone complete."