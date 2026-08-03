FROM docker.io/library/alpine:3.24

ARG TARGETPLATFORM
ARG VERSION

USER root

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        irqbalance="${VERSION}"

ENTRYPOINT ["/usr/sbin/irqbalance", "--foreground"]

LABEL org.opencontainers.image.source="https://github.com/irqbalance/irqbalance"
