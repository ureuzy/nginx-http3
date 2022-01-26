FROM debian:latest as builder

ENV WORK_DIR /opt/work
WORKDIR $WORK_DIR

RUN apt update && apt install -y \
    mercurial \
    make \
    cmake \
    golang \
    gcc \
    g++ \
    git \
    openssl \
    zlib1g-dev \
    libpcre3-dev \
    libunwind-dev

RUN git clone https://boringssl.googlesource.com/boringssl
RUN hg clone -b quic https://hg.nginx.org/nginx-quic

# Build BoringSSL
RUN mkdir ${WORK_DIR}/boringssl/build
RUN cd ${WORK_DIR}/boringssl/build \
    && cmake .. \
    && make

# Test BoringSSL
#RUN cd ${WORK_DIR}/boringssl \
#    && go run util/all_tests.go
#RUN cd ${WORK_DIR}/boringssl/ssl/test/runner \
#    && go test

# Build Nginx/QUIC
RUN cd ${WORK_DIR}/nginx-quic \
    && ./auto/configure \
    --with-debug \
    --with-http_v3_module \
    --with-cc-opt="-I../boringssl/include" \
    --with-ld-opt="-L../boringssl/build/ssl -L../boringssl/build/crypto" \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    && make \
    && make install


FROM nginx:latest

RUN bash -c 'mkdir -p /var/{cache/nginx,www/html} /etc/nginx/certs'

COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY nginx.conf /etc/nginx

RUN cd /etc/nginx/certs \
    && openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -subj /CN=localhost -keyout server.key -out server.crt

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
