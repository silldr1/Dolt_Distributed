#!/bin/bash
set -e

doltlab_db=${DOLTLAB_DB}
if [ -z "$doltlab_db" ]; then
  doltlab_db="doltlab_doltlabdb_1"
fi

docker run \
--rm \
-it \
--entrypoint="" \
--volumes-from "$doltlab_db" \
dolthub/dolt \
/bin/bash
