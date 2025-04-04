#!/bin/bash
set -e

compose_command="docker compose"

set_compose_command() {
  eval "$compose_command" version > /dev/null 2>&1 || compose_command="docker-compose" && true
}

stop_services() {
  local config="/home/silldr1/Documents/Dolt_Distributed/doltlab/docker-compose.yaml"
  eval "$compose_command -f $config stop"
}

_main() {
    set_compose_command
    stop_services
}

_main "$@"
