# create dockerfile with elixir
FROM elixir:1.14-alpine

WORKDIR /app
# copy files in /app
COPY . .
# install Hex
RUN mix local.hex --force
# install phoenix
RUN mix archive.install hex phx_new
# install dependencies
RUN mix deps.get
# export port 4000
EXPOSE 4000