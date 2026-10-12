FROM python:3.14-slim

RUN apt-get update && apt-get install -y --no-install-recommends git curl ca-certificates && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv

RUN git clone --depth 1 https://github.com/Alishahryar1/free-claude-code /app

WORKDIR /app

RUN uv sync

RUN curl -sL https://github.com/caddyserver/caddy/releases/download/v2.10.2/caddy_2.10.2_linux_amd64.tar.gz | tar -xz -C /usr/local/bin caddy

COPY start.sh /start.sh

ENV HOST=127.0.0.1

EXPOSE 10000

CMD ["sh", "/start.sh"]
