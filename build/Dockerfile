FROM skafos/alpine-erlang:20.3.4

MAINTAINER Travis Sturzl <travis@metismachine.com>

ENV REFRESHED_AT=2018-05-07 \
    ELIXIR_VERSION=v1.6.4

RUN \
    apk --no-cache --update upgrade && \
    apk add --no-cache --update --virtual .elixir-build \
      make && \
    apk add --no-cache --update \
      git && \
    git clone https://github.com/elixir-lang/elixir && \
    cd elixir && \
    git checkout $ELIXIR_VERSION && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd $HOME && \
    rm -rf /tmp/elixir-build && \
    apk del .elixir-build

RUN apk --no-cache --update upgrade
RUN apk update
RUN apk --no-cache --update add git make g++

RUN mix local.hex --force && \
    mix local.rebar --force
