FROM alpine:3.15.0 AS base

# install unzip
RUN apk add --update-cache \
    unzip

# add the bootstrap file
COPY bootstrap.sh /terraria-server/bootstrap.sh

# get args
ARG DL_VERSION
ENV DL_LINK=https://terraria.org/api/download/pc-dedicated-server/terraria-server-$DL_VERSION.zip
ENV DL_FILE=terraria-server-$DL_VERSION.zip

# copy in server zip
ADD $DL_LINK /$DL_FILE

# unzip the server files
RUN unzip /$DL_FILE -d /terraria && \
    mv /terraria/$DL_VERSION/Linux/* /terraria-server && \
    #Linux subfolder does not include any config text file, oddly.
    mv /terraria/$DL_VERSION/Windows/serverconfig.txt /terraria-server/serverconfig-default.txt && \
    chmod +x /terraria-server/TerrariaServer && \
    chmod +x /terraria-server/TerrariaServer.bin.x86_64

# make final image based off mono runtime
FROM mono:6.10.0.104-slim
LABEL maintainer="Ryan Sheehan <rsheehan@gmail.com>"

# documenting ports
EXPOSE 7777

# env used in the bootstrap
ENV LOGPATH=/terraria-server/logs
ENV WORLDPATH=/root/.local/share/Terraria/Worlds
ENV WORLD_FILENAME=""
ENV CONFIGPATH=/config
ENV CONFIG_FILENAME="serverconfig.txt"

# create volumes
VOLUME [ "${WORLDPATH}", "${CONFIGPATH}", "${LOGPATH}" ]

# copy in server files from base image
COPY --from=base /terraria-server/ /terraria-server/

# set working directory to server
WORKDIR /terraria-server

# set entrypoint
ENTRYPOINT [ "/bin/bash", "bootstrap.sh" ]