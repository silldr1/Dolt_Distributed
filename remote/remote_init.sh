#!/bin/sh

# Optional: configure user identity
dolt config --global --add user.name "dolt-remote"
dolt config --global --add user.email "dolt-remote@localhost"


echo "Initializing Dolt repository..."
cd /root/dolt
dolt init
dolt sql < /db_init.sql
dolt add .
dolt commit -m "init database"
mkdir -p /dolt-remote/test-repo
dolt remote add origin file:///dolt-remote/test-repo
dolt push origin main


touch /dolt-remote/.ready


# Append non-root user before starting SQL server.
echo "Creating non-root user..."
dolt sql -q "CREATE USER IF NOT EXISTS 'Local Node'@'%' IDENTIFIED WITH mysql_native_password BY 'password';"
dolt sql -q "GRANT ALL PRIVILEGES ON *.* TO 'Local Node'@'%';"
dolt sql -q "FLUSH PRIVILEGES;"

# Step 3: Start Dolt SQL server
exec dolt sql-server -H 0.0.0.0 --port 3306




