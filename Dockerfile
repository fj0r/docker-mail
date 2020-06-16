FROM ubuntu:focal

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TIMEZONE=Asia/Shanghai
ENV watchexec_version=1.13.1

ARG watchexec_url=https://github.com/watchexec/watchexec/releases/download/${watchexec_version}/watchexec-${watchexec_version}-x86_64-unknown-linux-musl.tar.xz

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ca-certificates sudo curl \
    tzdata locales xz-utils \
        sqlite3 \
        postfix \
        dovecot-core dovecot-imapd dovecot-lmtpd \
        dovecot-sqlite postfix-sqlite \
        opendkim opendkim-tools \
  \
  ; sed -i 's/^.*\(%sudo.*\)ALL$/\1NOPASSWD:ALL/g' /etc/sudoers \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; sed -i /etc/locale.gen \
    -e 's/# \(en_US.UTF-8 UTF-8\)/\1/' \
    -e 's/# \(zh_CN.UTF-8 UTF-8\)/\1/' \
  ; locale-gen \
  \
  ; curl -sSL ${watchexec_url} \
      | tar Jxf - --strip-components=1 -C /usr/local/bin watchexec-${watchexec_version}-x86_64-unknown-linux-musl/watchexec \
  \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY etc/postfix /etc

RUN set -eux \
  ; groupadd --system vmail -g 5000 \
  ; useradd --system vmail -u 5000 -g 5000 \
  ; mkdir -p /var/spool/mail/virtual \
  ; chown -R vmail:vmail /var/spool/mail/virtual \
  ; chmod 770 /var/spool/mail/virtual \
  ; chown -R vmail:dovecot /etc/dovecot \
  ; chmod -R o-rwx /etc/dovecot

ENV DOMAIN=
EXPOSE 25 465 587 110 995 143 993