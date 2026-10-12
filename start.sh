#!/bin/sh
set -e
: "${BASIC_PASS:?BASIC_PASS is required}"
HASH=$(caddy hash-password --plaintext "$BASIC_PASS")
PORT="${PORT:-10000}"
printf ':%s\n\n@health path /\nrespond @health 204\n\nbasic_auth {\n    inder %s\n}\n\nreverse_proxy 127.0.0.1:8082 {\n    header_up Host 127.0.0.1:8082\n    header_up -Origin\n}\n' "$PORT" "$HASH" > /app/Caddyfile
HOST=127.0.0.1 PORT=8082 uv run fcc-server &
caddy run --config /app/Caddyfile
