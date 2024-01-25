# Nginx RTMP SSL

A docker container based on the [original by mvgorcum](https://github.com/mvgorcum/docker-nginx-ts). Improved config generation and support for SSL for the stream urls.

# Usage

Run the container specifying the `SERVER_NAME` and providing the certificates.

## Certificates

Mount a folder to `/var/ssl` that contains `cert.crt` the PEM certificate, `cert.key` the private key for the cert and `pass.txt` the PEM passphrase (can be an empty file if no passphase is needed).

## Ports

 - 1935 - Used for RTMP ingest.
 - 443 - Used for serving the dash and HLS content.

## Environment Variables

|Variable|Default|About|
|:-------|:-----:|:-------|
|`SERVER_NAME`|_none, required_|Sets the `server_name` of the http server in nginx for example `rtmp.exmaple.com`.|
|`DASH_PLAYLIST_LENGTH`|`30s`|Sets the playlist length for dash, a lower value reduces delay but requires a faster client connection.|

## Docker Compose

Create a `docker-compose.yml` with this content:

```yml
version: '3.9'
services:
  db:
    image: longridgehighschool/nginx-rtmp-ssl:latest
    restart: always
    environment:
      SERVER_NAME: rtmp.example.com
    volumes:
      - /path/to/certs:/var/ssl
    ports:
      - '1935:1935'
      - '8443:443'
```