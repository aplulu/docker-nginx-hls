FROM alpine:3.12.3
MAINTAINER Aplulu <aplulu.liv@gmail.com>

ENV ALLOW_PUBLISH=172.17.0.1
ENV HLS_PLAYLIST_LENGTH=4s
ENV HLS_FRAGMENT=1s

ENV NGINX_VERSION=1.18.0
ENV RTMP_MODULE_VERSION=1.2.1

RUN apk update && \
    apk add --no-cache ca-certificates pcre && \
    update-ca-certificates && \
	apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		openssl-dev \
		pcre-dev \
		zlib-dev \
		linux-headers \
		curl \
		gnupg \
		libxslt-dev && \
	mkdir -p /tmp/build/nginx && \
    cd /tmp/build/nginx && \
    wget -O nginx-${NGINX_VERSION}.tar.gz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxf nginx-${NGINX_VERSION}.tar.gz && \
    mkdir -p /tmp/build/nginx-rtmp-module && \
    cd /tmp/build/nginx-rtmp-module && \
    wget -O nginx-rtmp-module-${RTMP_MODULE_VERSION}.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_MODULE_VERSION}.tar.gz && \
    tar -zxf nginx-rtmp-module-${RTMP_MODULE_VERSION}.tar.gz && \
    cd nginx-rtmp-module-${RTMP_MODULE_VERSION} && \
	cd /tmp/build/nginx/nginx-${NGINX_VERSION} && \
    ./configure \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --with-http_ssl_module \
        --with-threads \
        --with-ipv6 \
        --with-cc-opt="-Wimplicit-fallthrough=0" \
        --add-module=/tmp/build/nginx-rtmp-module/nginx-rtmp-module-${RTMP_MODULE_VERSION} && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install && \
    mkdir /var/lock/nginx && \
    mkdir /tmp/hls && \
    rm -rf /tmp/build && \
    apk del .build-deps && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh
COPY public/ /usr/share/nginx/html/
RUN chmod +x /entrypoint.sh

EXPOSE 80
EXPOSE 1935
ENTRYPOINT ["/entrypoint.sh"]
