FROM buildpack-deps:bookworm AS builder

#RUN apt update && apt install -y --no-install-recommends git

ARG REPO=https://github.com/NLnetLabs/nsd
ARG TAG=master

RUN git clone --depth 1 --branch "${TAG}" "${REPO}" /src

WORKDIR /src

RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    bison \
    flex \
    libevent-dev \
    libfstrm-dev \
    libprotobuf-c-dev \
    openssl \
    protobuf-c-compiler \
    protobuf-compiler

# build & install into /app
RUN git submodule update --init \
    && autoreconf -fi \
    && ./configure --with-nsd_conf_file=/etc/nsd.conf \
    && make \
    && DESTDIR=/app make install

FROM debian:stable-slim

RUN apt update && apt install -y --no-install-recommends \
    libevent-2.1-7 \
    libfstrm0 \
    libprotobuf-c1 \
    openssl

RUN groupadd -g 1000 nsd \
    && useradd -u 1000 -g nsd -d / -r -M nsd

WORKDIR /etc/nsd
USER nsd

ENTRYPOINT ["/usr/local/sbin/nsd"]
VOLUME /etc/nsd
EXPOSE 5333/udp 5333/tcp

# copy the built artifacts
COPY --from=builder /app/* /usr
# include your default config
COPY nsd.conf /etc/nsd.conf

