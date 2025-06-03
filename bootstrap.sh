# Copy this file into the sql dumps folder

#!/bin/sh
set -e

cd /root/dolt

# Initialize dolt repo if it doesn't exist
if [ ! -d "mydb" ]; then
  dolt init -n mydb
fi

cd mydb

# Keep a log of processed files
PROCESSED_LOG="/root/dolt/mydb/.processed_sql_files"

# Create log file if it doesn't exist
touch "$PROCESSED_LOG"

# Process only new SQL files
for sql_file in /sql_dumps/*.sql; do
  filename=$(basename "$sql_file")
  if ! grep -Fxq "$filename" "$PROCESSED_LOG"; then
    echo "Processing new SQL file: $filename"
    dolt sql < "$sql_file"
    echo "$filename" >> "$PROCESSED_LOG"
    dolt add .
    dolt commit -m "Loaded new SQL dump: $filename"
  else
    echo "Already processed: $filename"
  fi
done
