FROM elixir:1.5
MAINTAINER Nico Grashoff <ng@biqx.de>
ARG MIX_ENV
ENV MIX_ENV ${MIX_ENV:-prod}
WORKDIR /usr/src/biqx/
RUN mix local.hex --force
RUN mix local.rebar --force
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -yq nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ADD mix.* /usr/src/biqx/
RUN mix do deps.get, deps.compile
ADD . /usr/src/biqx/
WORKDIR /usr/src/biqx/assets/
RUN npm install
RUN node /usr/src/biqx/assets/node_modules/brunch/bin/brunch build
WORKDIR /usr/src/biqx/
RUN mix compile
CMD mix phx.server
