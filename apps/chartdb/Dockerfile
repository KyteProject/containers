FROM node:22-alpine AS builder

ARG VERSION
ARG TARGETPLATFORM
ARG CHANNEL
ARG VITE_OPENAI_API_KEY

WORKDIR /app

RUN \
  apk add --no-cache \
  git \
  && git clone --depth 1 --branch ${VERSION} https://github.com/chartdb/chartdb.git . \
  && npm ci \
  && VITE_OPENAI_API_KEY=${VITE_OPENAI_API_KEY} npm run build

FROM docker.io/library/alpine:3.21

ENV UMASK="0002" \
  TZ="Etc/UTC"

ENV OPENAI_API_KEY=""

USER root
WORKDIR /app

RUN \
  apk add --no-cache \
  bash \
  ca-certificates \
  catatonit \
  curl \
  jo \
  jq \
  nano \
  tzdata \
  envsubst \
  && mkdir -p /app/public

COPY --from=builder /app/dist /app/public
COPY ./apps/chartdb/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/chartdb/chartdb"
