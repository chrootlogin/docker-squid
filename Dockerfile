FROM alpine:3.8

ARG BUILD_DATE
ARG VCS_REF

ARG SQUID_VERSION=3.5.28

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
    alpine-sdk \
    bash \
    curl \
    file \
    heimdal \
    heimdal-dev \
    libcap \
    libcap-dev \
    libdbi-drivers \
    libldap \
    libressl \
    libressl-dev \
    libtool \
    linux-pam \
    linux-pam-dev \
    openldap-dev \
    perl \
    perl-dbd-mysql \
    perl-dbi \
    samba \
    samba-winbind-clients \
    tini \
    wget \
  && wget -q http://www.squid-cache.org/Versions/v3/${SQUID_VERSION%.*}/squid-${SQUID_VERSION}.tar.gz -O /tmp/squid.tgz \
  && mkdir /tmp/squid \
  && tar xzf /tmp/squid.tgz --strip-components=1 -C /tmp/squid \
  && cd /tmp/squid \
  && ./configure \
    --prefix=/usr \
    --datadir=/usr/share/squid \
    --sysconfdir=/etc/squid \
    --libexecdir=/usr/lib/squid \
    --localstatedir=/var \
    --with-logdir=/var/log/squid \
    --disable-strict-error-checking \
		--disable-arch-native \
		--enable-removal-policies="lru,heap" \
    --enable-auth-basic="getpwnam,DB,LDAP,NCSA,PAM,POP3,RADIUS,SASL,SMB,SMB_LM" \
    --enable-auth-digest="LDAP" \
    --enable-auth-negotiate="kerberos" \
    --enable-auth-ntlm="smb_lm" \
    --enable-log-daemon-helpers="DB,file" \
    --enable-epoll \
    --disable-mit \
		--enable-heimdal \
		--enable-delay-pools \
		--enable-arp-acl \
		--enable-openssl \
		--enable-ssl-crtd \
		--enable-linux-netfilter \
		--enable-ident-lookups \
		--enable-useragent-log \
		--enable-cache-digests \
		--enable-referer-log \
		--enable-async-io \
		--enable-truncate \
		--enable-arp-acl \
		--enable-htcp \
		--enable-carp \
		--enable-poll \
		--enable-follow-x-forwarded-for \
		--with-large-files \
		--with-default-user=squid \
		--with-openssl \
  && make all \
  && make install \
  && apk del \
    alpine-sdk \
    heimdal-dev \
    libcap-dev \
    libressl-dev \
    linux-pam-dev \
    openldap-dev \
  # Delete apk cache
  && rm -rf /var/cache/apk/*

COPY root /

VOLUME /cache /logs

EXPOSE 3128/tcp

HEALTHCHECK --interval=1m --timeout=3s \
  CMD squidclient -h localhost cache_object://localhost/counters || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-run.sh"]
