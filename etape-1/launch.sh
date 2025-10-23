#!/usr/bin/env bash
set -euo pipefail
export MSYS_NO_PATHCONV=1

# Chemin racine (Windows-style mais avec slash pour Docker)
ROOT="D:/Digital-Campus/samuel-Mrohaut/docker-tp3/etape-1"
NET_NAME="tp3-network"
HTTP_NAME="HTTP"
PHP_NAME="SCRIPT"

# Supprimer d'anciens containers et réseau s'ils existent
docker rm -f "$HTTP_NAME" "$PHP_NAME" 2>/dev/null || true
docker network rm "$NET_NAME" 2>/dev/null || true

# Créer le réseau
docker network create "$NET_NAME"

# Lancer le container PHP-FPM
docker run -d \
  --name "$PHP_NAME" \
  --network "$NET_NAME" \
  -v "$ROOT/src:/app" \
  php:8.2-fpm-alpine

# Lancer le container NGINX
docker run -d \
  --name "$HTTP_NAME" \
  --network "$NET_NAME" \
  -p 8080:80 \
  -v "$ROOT/src:/app" \
  -v "$ROOT/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable-alpine

echo "✅ Containers lancés !"
echo "🌐 Ouvre ton navigateur et visite : http://localhost:8080"
