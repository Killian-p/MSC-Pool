# create dockerfile with elixir
FROM elixir:1.14

WORKDIR /app
# copy files in /app
COPY . .
# -> Update base image
RUN apt-get update --yes -qq --option Acquire::Retries=5 > /dev/null && \
    apt-get install --yes -qq --option Acquire::Retries=5 > /dev/null && \
    apt-get autoclean --yes -qq > /dev/null && \
    apt-get autoremove --yes -qq > /dev/null

RUN apt-get install gcc -y
# install Hex
RUN mix local.hex --force && mix local.rebar --force
# install phoenix
RUN mix archive.install hex phx_new
# install dependencies
RUN mix deps.get && mix deps.compile && mix deps.compile --force bcrypt_elixir
# export port 4000
EXPOSE 4000