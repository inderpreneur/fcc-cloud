#!/bin/sh
set -e
: "${BASIC_PASS:?BASIC_PASS is required}"
HASH=$(caddy hash-password --plaintext "$BASIC_PASS")
PORT="${PORT:-10000}"
cat > /etc/caddy/Caddyfile <<CF
:${PORT}

@health path /
handle @health {
    respond 204
}

handle {
    basic_auth {
        inder ${HASH}
    }
    reverse_proxy 127.0.0.1:8082 {
        header_up Host 127.0.0.1:8082
        header_up -Origin
    }
}
CF
HOST=127.0.0.1 PORT=8082 uv run fcc-server &
caddy run --config /etc/caddy/Caddyfile
