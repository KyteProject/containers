FROM docker.io/library/node:22-alpine AS builder

ARG VERSION
ARG TARGETPLATFORM
ARG CHANNEL
ARG OPENAI_API_KEY

WORKDIR /app

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
  apk add --no-cache \
  git \
  && git clone --depth 1 --branch v${VERSION} https://github.com/chartdb/chartdb.git . \
  && npm ci \
  && VITE_OPENAI_API_KEY=${OPENAI_API_KEY} npm run build

FROM docker.io/library/alpine:3.21

ENV UMASK="0002" \
  TZ="Etc/UTC"

ENV OPENAI_API_KEY=""

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3013,DL3059,DL4006
RUN \
  apk add --no-cache \
  bash \
  busybox-extras \
  ca-certificates \
  catatonit \
  curl \
  jo \
  jq \
  nano \
  tzdata \
  envsubst \
  && mkdir -p /app/public \
  && chown -R nobody:nogroup /app

COPY --from=builder /app/dist /app/public
COPY ./apps/chartdb/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER nobody:nogroup
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/chartdb/chartdb"
