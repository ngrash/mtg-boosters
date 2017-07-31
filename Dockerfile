FROM elixir:1.5
MAINTAINER Nico Grashoff <ng@biqx.de>
ARG MIX_ENV
ENV MIX_ENV ${MIX_ENV:-prod}
WORKDIR /usr/src/biqx/
RUN mix local.hex --force
RUN mix local.rebar --force
ADD mix.* /usr/src/biqx/
RUN mix do deps.get, deps.compile
ADD . /usr/src/biqx/
RUN mix compile
CMD mix phx.server
