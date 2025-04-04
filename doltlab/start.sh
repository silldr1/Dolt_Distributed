




#!/bin/bash
set -e

export SMTP_SERVER_USERNAME=""
export SMTP_SERVER_PASSWORD=""
export SMTP_SERVER_OAUTH_TOKEN=""
export DEFAULT_USER_PASSWORD="DoltLab1234"
export DOLT_DOLTHUBAPI_PASSWORD="DoltLab1234"
export DOLT_ADMIN_PASSWORD="DoltLab1234"


compose_command="docker compose"

set_compose_command() {
  eval "$compose_command" version > /dev/null 2>&1 || compose_command="docker-compose" && true
}

check_env() {
  if [[ -z "$DOLT_ADMIN_PASSWORD" || -z "$DOLT_DOLTHUBAPI_PASSWORD" ]]; then
    echo "Must supply DOLT_ADMIN_PASSWORD, and DOLT_DOLTHUBAPI_PASSWORD"
    exit 1
  fi

}



create_docker_network_if_not_exists() {
  docker network inspect doltlab >/dev/null 2>&1 || \
  docker network create --driver bridge doltlab
}

start_services() {
  local config="/home/silldr1/Documents/Dolt_Distributed/doltlab/docker-compose.yaml"

  SMTP_SERVER_USERNAME="$SMTP_SERVER_USERNAME" \
  SMTP_SERVER_PASSWORD="$SMTP_SERVER_PASSWORD" \
  SMTP_SERVER_OAUTH_TOKEN="$SMTP_SERVER_OAUTH_TOKEN" \
  DEFAULT_USER_PASSWORD="$DEFAULT_USER_PASSWORD" \
  DOLT_ADMIN_PASSWORD="$DOLT_ADMIN_PASSWORD" \
  DOLT_DOLTHUBAPI_PASSWORD="$DOLT_DOLTHUBAPI_PASSWORD" \
  eval "$compose_command -f $config up -d"
}

_main() {
    set_compose_command
    check_env
    create_docker_network_if_not_exists
    start_services
}

_main "$@"
