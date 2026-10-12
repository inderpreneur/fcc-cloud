#!/bin/sh
set -e
: "${BASIC_PASS:?BASIC_PASS is required}"
HASH=$(caddy hash-password --plaintext "$BASIC_PASS")
PORT="${PORT:-10000}"
printf ':%s\n\n@health path /\nhandle @health {\n    respond 204\n}\n\nhandle {\n    basic_auth {\n        inder %s\n    }\n    reverse_proxy 127.0.0.1:8082 {\n        header_up Host 127.0.0.1:8082\n        header_up -Origin\n    }\n}\n' "$PORT" "$HASH" > /etc/caddy/Caddyfile
HOST=127.0.0.1 PORT=8082 uv run fcc-server &
caddy run --config /etc/caddy/Caddyfile
