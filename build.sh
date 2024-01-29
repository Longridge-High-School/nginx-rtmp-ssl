#!/bin/sh

NGINX_CONFIG_DIR=/opt/nginx/conf/
SNIPPETS_DIR=${NGINX_CONFIG_DIR}snippets/
STREAMS_DIR=${NGINX_CONFIG_DIR}streams/

RTMP_CONNECTIONS=${RTMP_CONNECTIONS-1024}
RTMP_STREAM_NAMES=${RTMP_STREAM_NAMES-live,testing}
RTMP_STREAMS=$(echo ${RTMP_STREAM_NAMES} | sed "s/,/\n/g")
RTMP_CONNECT_URLS=$(echo ${RTMP_CONNECT_URLS} | sed "s/,/\n/g")
RTMP_PLAY_URLS=$(echo ${RTMP_PLAY_URLS} | sed "s/,/\n/g")
RTMP_PUBLISH_URLS=$(echo ${RTMP_PUBLISH_URLS} | sed "s/,/\n/g")
RTMP_DONE_URLS=$(echo ${RTMP_DONE_URLS} | sed "s/,/\n/g")
DASH_PLAYLIST_LENGTH=${DASH_PLAYLIST_LENGTH-30s}
WORKER_PROCESSES=${WORKER_PROCESSES-1}


# Create Folders

mkdir -p ${SNIPPETS_DIR}
mkdir -p ${STREAMS_DIR}

# Create Snippets

echo "worker_connections ${RTMP_CONNECTIONS};" > ${SNIPPETS_DIR}worker_connections.txt

echo "server_name ${SERVER_NAME};" > ${SNIPPETS_DIR}server_name.txt

echo "worker_processes ${WORKER_PROCESSES};" > ${SNIPPETS_DIR}worker_processes.txt

# Create URLS Block

echo "" > "${SNIPPETS_DIR}urls.txt"

if [ "x${RTMP_CONNECT_URLS}" != "x" ]; then
  for CONNECT_URL in $(echo ${RTMP_CONNECT_URLS}); do
    echo "Creating Connect URL ${CONNECT_URL}"

    echo "on_connect ${CONNECT_URL};" >> "${SNIPPETS_DIR}urls.txt"
  done
fi

if [ "x${RTMP_PLAY_URLS}" != "x" ]; then
  for PLAY_URL in $(echo ${RTMP_PLAY_URLS}); do
    echo "Creating Play URL ${PLAY_URL}"

    echo "on_play ${PLAY_URL};" >> "${SNIPPETS_DIR}urls.txt"
  done
fi

if [ "x${RTMP_PUBLISH_URLS}" != "x" ]; then
  for PUBLISH_URL in $(echo ${RTMP_PUBLISH_URLS}); do
    echo "Creating Publish URL ${PUBLISH_URL}"

    echo "on_publish ${PUBLISH_URL};" >> "${SNIPPETS_DIR}urls.txt"
  done
fi

if [ "x${RTMP_DONE_URLS}" != "x" ]; then
  for DONE_URL in $(echo ${RTMP_DONE_URLS}); do
    echo "Creating Done URL ${DONE_URL}"

    echo "on_done ${DONE_URL};" >> "${SNIPPETS_DIR}urls.txt"
  done
fi

# Create Streams

for STREAM_NAME in $(echo ${RTMP_STREAMS}) 
do
  echo Creating stream $STREAM_NAME

  sed "s/_STREAM_NAME_/$STREAM_NAME/;s/_DASH_PLAYLIST_LENGTH_/$DASH_PLAYLIST_LENGTH/" /run/stream.conf > "$STREAMS_DIR$STREAM_NAME.conf"
done
