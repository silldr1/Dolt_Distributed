#!/bin/sh
set -e
export PATH="/root/bin:$PATH"

NODE_NAME=$(hostname)
REPO_NAME="test"
DOLTLAB_USER="admin"
DOLTLAB_REMOTE="http://10.109.8.211:50051/${DOLTLAB_USER}/${REPO_NAME}"
LOCAL_PATH="/root/dolt"

# Dolt user config and credentials
dolt config --global --add user.name "admin"
dolt config --global --add user.email "admin@localhost"
dolt creds import /root/creds/*.jwk
dolt creds use $(dolt creds ls | awk '/^\*/ {print $2}')

echo "[$NODE_NAME] Starting Dolt init..."

if [ "$NODE_NAME" = "node1" ]; then
  mkdir -p "$LOCAL_PATH"
  cd "$LOCAL_PATH"
  dolt init
  dolt sql -q "CREATE TABLE IF NOT EXISTS test (id INT PRIMARY KEY, name VARCHAR(100));"
  dolt add .
  dolt commit -m "Initial commit"
  dolt remote add origin "$DOLTLAB_REMOTE"
  dolt push origin main -f
else
  sleep 20
  echo "Attempting to clone from DoltLab..."
  until dolt clone "$DOLTLAB_REMOTE" "$LOCAL_PATH"; do
    echo "Clone failed. Retrying in 10 seconds..."
    sleep 10
  done
  echo "[$NODE_NAME] Clone successful."
  cd "$LOCAL_PATH"
  dolt pull origin main || true
fi
