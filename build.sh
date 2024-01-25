#!/bin/sh

NGINX_CONFIG_DIR=/opt/nginx/conf/
SNIPPETS_DIR=${NGINX_CONFIG_DIR}snippets/
STREAMS_DIR=${NGINX_CONFIG_DIR}streams/

RTMP_CONNECTIONS=${RTMP_CONNECTIONS-1024}
RTMP_STREAM_NAMES=${RTMP_STREAM_NAMES-live,testing}
RTMP_STREAMS=$(echo ${RTMP_STREAM_NAMES} | sed "s/,/\n/g")
RTMP_PUSH_URLS=$(echo ${RTMP_PUSH_URLS} | sed "s/,/\n/g")


# Create Folders

mkdir -p ${SNIPPETS_DIR}
mkdir -p ${STREAMS_DIR}

# Create Snippets

echo "worker_connections ${RTMP_CONNECTIONS};" >> ${SNIPPETS_DIR}worker_connections.txt

echo "server_name ${SERVER_NAME};" >> ${SNIPPETS_DIR}server_name.txt

# Create Streams

if [ "x${RTMP_PUSH_URLS}" = "x" ]; then
    PUSH="false"
else
    PUSH="true"
fi

for STREAM_NAME in $(echo ${RTMP_STREAMS}) 
do

  echo Creating stream $STREAM_NAME

  sed "s/_STREAM_NAME_/$STREAM_NAME/" /run/stream.conf > "$STREAMS_DIR$STREAM_NAME.conf"

done
