FROM ubuntu:focal

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TIMEZONE=Asia/Shanghai

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        ca-certificates sudo curl git \
        tzdata locales xz-utils \
        sqlite3 \
        postfix \
        dovecot-core dovecot-imapd dovecot-lmtpd \
        dovecot-sqlite postfix-sqlite \
        opendkim opendkim-tools \
        python3 pytho3-neovim \
  \
  ; sed -i 's/^.*\(%sudo.*\)ALL$/\1NOPASSWD:ALL/g' /etc/sudoers \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; sed -i /etc/locale.gen \
    -e 's/# \(en_US.UTF-8 UTF-8\)/\1/' \
    -e 's/# \(zh_CN.UTF-8 UTF-8\)/\1/' \
  ; locale-gen \
  \
  ; curl -sSL https://github.com/neovim/neovim/releases/download/${NVIM_VERSION:-nightly}/nvim-linux64.tar.gz \
      | tar zxf - -C /usr/local --strip-components=1 \
  ; mkdir -p ~/.config \
  ; git clone --depth=1 https://github.com/murphil/nvim ~/.config/nvim \
  \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV watchexec_version=1.14.1
ENV s6overlay_version=2.1.0.2

ARG watchexec_url=https://github.com/watchexec/watchexec/releases/download/${watchexec_version}/watchexec-${watchexec_version}-x86_64-unknown-linux-musl.tar.xz
ARG s6overlay_url=https://github.com/just-containers/s6-overlay/releases/download/v${s6overlay_version}/s6-overlay-amd64.tar.gz

RUN set -eux \
  ; curl -sSL ${watchexec_url} \
      | tar Jxf - --strip-components=1 -C /usr/local/bin watchexec-${watchexec_version}-x86_64-unknown-linux-musl/watchexec \
  \
  ; curl -sSL ${s6overlay_url} > /tmp/s6overlay.tar.gz \
  ; tar xzf /tmp/s6overlay.tar.gz -C / --exclude="./bin" \
  ; tar xzf /tmp/s6overlay.tar.gz -C /usr ./bin \
  ; rm -f /tmp/s6overlay.tar.gz


COPY etc/postfix /etc/postfix
COPY etc/dovecot /etc/dovecot

RUN set -eux \
  ; groupadd --system vmail -g 5000 \
  ; useradd --system vmail -u 5000 -g 5000 \
  ; mkdir -p /var/spool/mail/virtual \
  ; chown -R vmail:vmail /var/spool/mail/virtual \
  ; chmod 770 /var/spool/mail/virtual \
  ; chown -R vmail:dovecot /etc/dovecot \
  ; chmod -R o-rwx /etc/dovecot

ENV DOMAIN=
ENV EXTERNAL_IP=
ENV MASTER=
EXPOSE 25 465 587 110 995 143 993
