#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-local}" # local | ci

if [[ "$MODE" == "ci" ]]; then
  echo "[teardown] CI cleanup: stop + remove volumes"
  docker compose -f medibook/docker-compose.yml down -v --remove-orphans #on supprime les volumes et down les containers
else
  echo "[teardown] Local cleanup: stop containers (keep volumes)" 
  docker compose -f medibook/docker-compose.yml down --remove-orphans #on down les containers seulement
fi