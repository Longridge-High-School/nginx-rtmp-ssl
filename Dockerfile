FROM alpine:latest as builder

ARG NGINX_VERSION=1.25.3
ARG NGINX_RTMP_VERSION=1.2.2


RUN	apk update		&&	\
	apk add				\
		git			\
		gcc			\
		binutils		\
		gmp			\
		libgomp			\
		libatomic		\
		libgcc			\
		openssl			\
		pkgconf			\
		pkgconfig		\
		mpc1			\
		libstdc++		\
		ca-certificates		\
		libssh2			\
		curl			\
		expat			\
		pcre			\
		musl-dev		\
		libc-dev		\
		pcre-dev		\
		zlib-dev		\
		openssl-dev		\
		curl			\
		make


RUN	cd /tmp/									&&	\
	curl --remote-name http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz			&&	\
	git clone https://github.com/arut/nginx-rtmp-module.git -b v${NGINX_RTMP_VERSION}

RUN	cd /tmp										&&	\
	tar xzf nginx-${NGINX_VERSION}.tar.gz						&&	\
	cd nginx-${NGINX_VERSION}							&&	\
	./configure										\
		--prefix=/opt/nginx								\
		--with-http_ssl_module								\
		--add-module=../nginx-rtmp-module					\
		--with-cc-opt="-Wimplicit-fallthrough=0" &&	\
	make										&&	\
	make install

FROM alpine:latest
RUN apk update		&& \
	apk add			   \
		openssl		   \
		libstdc++	   \
		ca-certificates	   \
		pcre

COPY --from=0 /opt/nginx /opt/nginx
COPY --from=0 /tmp/nginx-rtmp-module/* /opt/nginx/conf/

RUN mkdir -p /run
ADD build.sh /run/build.sh
ADD run.sh /run/run.sh

RUN chmod +x /run/run.sh
RUN chmod +x /run/build.sh

ADD nginx/stream.conf /run/stream.conf
ADD nginx/nginx.conf /opt/nginx/conf/nginx.conf

RUN mkdir -p /tmp/hls
RUN mkdir -p /tmp/dash

EXPOSE 1935
EXPOSE 443

CMD /run/run.sh