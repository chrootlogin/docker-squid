FROM alpine:3.7
LABEL maintainer="Simon Erhardt <hello@rootlogin.ch>"

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
