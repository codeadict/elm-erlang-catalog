FROM erlang:slim
MAINTAINER Dairon Medina <me@dairon.org>

RUN mkdir /build
RUN mkdir /app
ADD . /build

RUN set -xe \
    && buildDeps=' \
    		curl \
    		nodejs-legacy \
    		npm \
    		git \
    		make \
    		curl \
    ' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && npm install -g elm elm-test --silent \
    && cd /build \
    && make install \
    && make \
    && mv _build/default/rel/catalog /app \
    && cd / \
    && rm -rf /build \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

EXPOSE 4000
CMD ["/app/catalog/bin/catalog", "foreground"]
