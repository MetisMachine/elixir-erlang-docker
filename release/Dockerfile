FROM alpine:3.7

MAINTAINER Travis Sturzl <travis@metismachin.com>

ENV REFRESHED_AT=2018-04-24 \
    LANG=en_US.UTF-8 \
    HOME=/opt/app/ \
    # Set this so that CTRL+G works properly
    TERM=xterm \
    ERLANG_VERSION=20.3.4

ENV ENVCONSUL_VERSION=0.7.3

WORKDIR /tmp/erlang-build

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --no-cache --upgrade apk-tools@edge

# Install Erlang
RUN \
    # Create default user and home directory, set owner to default
    mkdir -p ${HOME} && \
    adduser -s /bin/sh -u 1001 -G root -h ${HOME} -S -D default && \
    chown -R 1001:0 ${HOME} && \
    # Add edge repos tagged so that we can selectively install edge packages
    echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    # Upgrade Alpine and base packages
    apk --no-cache upgrade && \
    # Install Erlang/OTP deps
    apk add --no-cache pcre@edge && \
    apk add --no-cache \
      ca-certificates \
      openssl-dev \
      ncurses-dev \
      unixodbc-dev \
      zlib-dev && \
    # Install Erlang/OTP build deps
    apk add --no-cache --virtual .erlang-build \
      git autoconf build-base perl-dev && \
    # Shallow clone Erlang/OTP
    git clone -b OTP-$ERLANG_VERSION --single-branch --depth 1 https://github.com/erlang/otp.git . && \
    # Erlang/OTP build env
    export ERL_TOP=/tmp/erlang-build && \
    export PATH=$ERL_TOP/bin:$PATH && \
    export CPPFlAGS="-D_BSD_SOURCE $CPPFLAGS" && \
    # Configure
    ./otp_build autoconf && \
    ./configure --prefix=/usr \
      --sysconfdir=/etc \
      --mandir=/usr/share/man \
      --infodir=/usr/share/info \
      --without-javac \
      --without-wx \
      --without-debugger \
      --without-observer \
      --without-jinterface \
      --without-cosEvent\
      --without-cosEventDomain \
      --without-cosFileTransfer \
      --without-cosNotification \
      --without-cosProperty \
      --without-cosTime \
      --without-cosTransactions \
      --without-dialyzer \
      --without-et \
      --without-gs \
      --without-ic \
      --without-megaco \
      --without-orber \
      --without-percept \
      --without-typer \
      --enable-threads \
      --enable-shared-zlib \
      --enable-ssl=dynamic-ssl-lib \
      --enable-hipe && \
    # Build
    make -j4 && make install && \
    # Cleanup
    apk del --force .erlang-build && \
    cd $HOME && \
    rm -rf /tmp/erlang-build && \
    # Update ca certificates
    update-ca-certificates --fresh

RUN apk --no-cache --update upgrade
RUN apk update && \
    apk --no-cache --update add libgcc libstdc++ bash && \
    rm -rf /var/cache/apk/*

RUN wget "https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.tgz" && \
  tar xf envconsul_${ENVCONSUL_VERSION}_linux_amd64.tgz && \
  rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.tgz && \
  mv envconsul /usr/local/bin && \
  chmod 0555 /usr/local/bin/envconsul

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint && \
  mkdir -p /etc/envconsul && \
  chmod 0555 -R /etc/envconsul

WORKDIR ${HOME}

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["/bin/bash"]
