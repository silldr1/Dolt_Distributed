#!/bin/bash
set -e

export DOLT_PASSWORD="DoltLab1234"

if [ -z "$DOLT_PASSWORD" ]; then
  echo "Must supply DOLT_PASSWORD to open database shell"
  exit 1
fi

host="doltlabdb"
port="3306"
network="doltlab"

doltlabadmin_username="dolthubadmin"
doltlabapi_dbname="dolthubapi"

docker run \
--rm \
-it \
--network "$network" \
-e MYSQL_PWD="$DOLT_PASSWORD" \
mysql:8.0.28 \
bash -c \
"mysql --user=$doltlabadmin_username --host=$host --port=$port --database=$doltlabapi_dbname"
