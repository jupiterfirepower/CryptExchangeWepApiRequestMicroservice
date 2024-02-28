#===========
#Build Stage
#===========
FROM elixir:alpine as build

#Copy the source folder into the Docker image
COPY . .

RUN apk update \
    && apk upgrade \
    && apk --update add g++ make cmake libc-dev libgcc musl   

RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    rm -Rf .elixir-tools && \
    rm -Rf deps && \
    #mix deps.clean --all && \
    #mix local.hex --force && \
    #mix local.rebar && \
    mix deps.get && \
    #mix local.rebar && \
    #mix deps.compile snappyer --force && \
    #mix deps.compile && \
    #mix deps.clean snappyer && \
    #mix deps.compile snappyer --force && \ 
    #mix deps.update snappyer && \
    mix release

ENV APP_NAME cermicros
RUN export RELEASE_DIR=`ls -d _build/prod` && \
mkdir /export && \
tar -xf "$RELEASE_DIR/$APP_NAME-0.1.0.tar.gz" -C /export

#================
#Deployment Stage
#================
FROM erlang:alpine

RUN apk --update --no-cache add bash
#Set environment variables and expose port
EXPOSE 4000
ENV REPLACE_OS_VARS=true \
    PORT=4000

WORKDIR /opt/app/cerm

#Copy and extract .tar.gz Release file from the previous stage
COPY --from=build /export/ .

#Set default entrypoint and command
CMD ["/opt/app/cerm/bin/cermicros", "start"]
