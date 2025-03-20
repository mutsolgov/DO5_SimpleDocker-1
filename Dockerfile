FROM debian:latest
WORKDIR /i_s
RUN apt-get update && apt-get install -y \
    spawn-fcgi \
    libfcgi-dev \
    nginx \
    gcc \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -d /home/ -m -s /bin/bash gerdalor \
    && chown -R gerdalor:gerdalor /usr/bin \
    && chown -R gerdalor:gerdalor /usr/sbin \
    && chown -R gerdalor:gerdalor /var \
    && chown -R gerdalor:gerdalor /run

COPY ./mini_server.c .

RUN gcc -o mini_server mini_server.c -lfcgi

COPY nginx/nginx.conf /etc/nginx/nginx.conf
HEALTHCHECK --interval=30s --timeout=10s \
    CMD curl -f http://localhost:8080/ || exit 1
USER gerdalor

CMD spawn-fcgi -p 8080 mini_server & nginx -g 'daemon off;'
