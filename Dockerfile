FROM alpine:3.7

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Simon Erhardt <hello@rootlogin.ch>" \
  org.label-schema.name="Squid" \
  org.label-schema.description="Minimal Squid docker image based on Alpine Linux." \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/chrootLogin/docker-squid" \
  org.label-schema.schema-version="1.0"

RUN set -ex \
  # Install packages
  && apk add --update \
  bash \
  curl \
  squid \
  tini \
  # Delete apk cache
  && rm -rf /var/cache/apk/*

COPY root /

VOLUME /cache /logs

EXPOSE 3128/tcp

HEALTHCHECK --interval=1m --timeout=3s \
  CMD squidclient -h localhost cache_object://localhost/counters || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-run.sh"]
