# Docker RTMP SSL

A docker container based on the [original by mvgorcum](https://github.com/mvgorcum/docker-nginx-ts). Improved config generation and support for SSL for the stream urls.

# Usage

## Docker Compose

Create a `docker-compose.yml` with this content:

```yml
version: '3.9'
services:
  db:
    image: longridgehighschool\nginx-rtmp-ssl:latest
    restart: always
    environment:
      SERVER_NAME: rtmp.example.com
    volumes:
      - /path/to/certs:/var/ssl
    ports:
      - '1935:1935'
      - '8443:443'
```

<!--
Removed Packages:

isl \
-->