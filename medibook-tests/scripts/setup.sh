#!/usr/bin/env bash
set -euo pipefail

echo "[setup] Start MediBook stack..."
docker compose -f medibook/docker-compose.yml up -d --build #on build les images et on demarre les containers 

echo "[setup] Wait for frontend http://localhost:3000 ..."
for i in {1..30}; do # on attend que le frontend soit dispo (max 1min)
  if curl -fsS http://localhost:3000 >/dev/null; then
    echo "[setup] Frontend OK"
    exit 0
  fi
  sleep 2
done

echo "[setup] Frontend not ready"
docker compose -f medibook/docker-compose.yml ps
docker compose -f medibook/docker-compose.yml logs --tail 200 # on affiche les logs des containers
exit 1