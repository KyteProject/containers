FROM docker.io/library/node:22-alpine AS builder

ARG VERSION
ARG TARGETPLATFORM
ARG CHANNEL

WORKDIR /app

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
  apk add --no-cache \
  git \
  && git clone --depth 1 --branch v${VERSION} https://github.com/chartdb/chartdb.git . \
  && npm ci \
  && VITE_OPENAI_API_KEY=OPENAI_API_KEY_PLACEHOLDER npm run build

FROM docker.io/library/alpine:3.21

ENV UMASK="0002" \
  TZ="Etc/UTC"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
  apk add --no-cache \
  bash \
  ca-certificates \
  catatonit \
  curl \
  jo \
  jq \
  nano \
  python3 \
  tzdata \
  && mkdir -p /app/public /run/secrets \
  && chown -R nobody:nogroup /app /run/secrets

COPY --from=builder /app/dist /app/public
COPY ./apps/chartdb/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER nobody:nogroup
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/chartdb/chartdb"
