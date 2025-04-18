#!/bin/sh
set -e


dolt config --global --add user.name "$(hostname)"
dolt config --global --add user.email "$(hostname)@localhost"

echo "Waiting for remote to finish push..."
until [ -f /dolt-remote/.ready ]; do
  echo "Waiting for remote"
  sleep 5
done

echo "Cloning from shared Dolt remote..."
cd /root
dolt clone file:///dolt-remote/test-repo dolt

echo "Clone complete."


# Start the SQL server to serve live queries.
cd dolt  # Ensure you’re in the repository directory.
dolt checkout main
echo "Starting Dolt SQL server on $(hostname)..."
exec dolt sql-server -H 0.0.0.0 --port 3306