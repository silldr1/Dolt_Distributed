#!/bin/sh
export PATH="/root/bin:$PATH"
set -e

dolt config --global --add user.name "Test"
dolt config --global --add user.email "test@example.com"

NODE_NAME=$(hostname)
REPO_NAME="main.git"
LOCAL_PATH="/root/dolt"
REMOTE_PATH="/dolt-remote/$REPO_NAME"
READY_MARKER="/dolt-remote/.node1_ready"

echo "[$NODE_NAME] Starting Dolt init process..."

# 1. Check if repo is already initialized
if [ -d "$LOCAL_PATH/.dolt" ]; then
  echo "[$NODE_NAME] Repo already initialized. Skipping clone/init."
  cd $LOCAL_PATH
else
  echo "[$NODE_NAME] Cloning or initializing repo..."
  if [ "$NODE_NAME" = "node1" ]; then
    cd /root/dolt
    # Node1 creates the repo
    dolt init
    dolt sql -q "CREATE TABLE IF NOT EXISTS test (id INT PRIMARY KEY, name VARCHAR(100));"
    dolt add .
    dolt commit -am "Initial commit from node1"
    mkdir -p $REMOTE_PATH
    dolt remote add origin file://$REMOTE_PATH
    dolt push origin main
    touch $READY_MARKER
  else
    # Wait for node1 to create the repo
    echo "[$NODE_NAME] Waiting for $READY_MARKER..."
    while [ ! -f "$READY_MARKER" ]; do
      echo "[$NODE_NAME] Still waiting for Node1 to finish init..."
      sleep 2
    done
    echo "[$NODE_NAME] Marker found. Cloning repo..."
    cd /root
    dolt clone file://$REMOTE_PATH dolt
    cd dolt
    echo "[$NODE_NAME] Clone complete."
  fi
fi

# 2. Ensure branch exists
dolt checkout -b $NODE_NAME-branch || dolt checkout $NODE_NAME-branch

mkdir -p /dolt-remote/logs
mkdir -p /dolt-remote/schema

# 3. Start export loop
echo "[$NODE_NAME] Starting schema/log export loop..."
while true; do
  dolt sql -q "SELECT * FROM dolt_log" -r json > /dolt-remote/logs/${NODE_NAME}.json
#  dolt schema show --json > /dolt-remote/${NODE_NAME}_schema.json || true
  sleep 10
done
