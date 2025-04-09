#!/bin/sh

REPO_NAME=test


# Optional: configure user identity
dolt config --global --add user.name "$(hostname)"
dolt config --global --add user.email "$(hostname)@example.com"

# Wait for remote to be ready
while [ ! -f /dolt-remote/.ready ]; do
  echo "Waiting for dolt-remote to be ready..."
  sleep 5
done
echo "dolt-remote is ready."

sleep 5


cd /root

# Only clone if not already initialized
if [ ! -d "$REPO_NAME" ]; then
  dolt clone file:///dolt-remote/$REPO_NAME $REPO_NAME
fi

cd $REPO_NAME

