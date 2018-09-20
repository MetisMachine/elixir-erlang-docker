FROM skafos/alpine-erlang:20.3.8.9

MAINTAINER Travis Sturzl <travis@metismachine.com>

ENV REFRESHED_AT=2018-09-18 \
    ELIXIR_VERSION=v1.6.6

WORKDIR /tmp/elixir-build

RUN apk --no-cache --update add git make g++

RUN \
    apk --no-cache --update upgrade && \
    apk add --no-cache --update --virtual .elixir-build \
      make && \
    apk add --no-cache --update \
      git && \
    git clone https://github.com/elixir-lang/elixir --depth 1 --branch $ELIXIR_VERSION && \
    cd elixir && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd $HOME && \
    rm -rf /tmp/elixir-build && \
    apk del --force-broken-world .elixir-build

