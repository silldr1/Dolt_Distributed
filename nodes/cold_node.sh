#!/bin/sh
set -e

# Configure repository identity
dolt config --global --add user.name "$(hostname)"
dolt config --global --add user.email "$(hostname)@localhost"

echo "Waiting for remote to finish push..."
until [ -f /dolt-remote/.ready ]; do
  echo "Waiting for remote..."
  sleep 5
done

echo "Cloning from shared Dolt remote..."
cd /root
dolt clone file:///dolt-remote/test-repo dolt
echo "Clone complete."

cd dolt   # Enter the repository.
dolt checkout main

dolt sql -q "CREATE USER IF NOT EXISTS '$(hostname)'@'%' IDENTIFIED WITH mysql_native_password BY 'password';"
dolt sql -q "GRANT SELECT ON *.* TO '$(hostname)'@'%';"
dolt sql -q "FLUSH PRIVILEGES;"


echo "Starting Dolt SQL server on $(hostname)..."
exec dolt sql-server -H 0.0.0.0 --port 3306
