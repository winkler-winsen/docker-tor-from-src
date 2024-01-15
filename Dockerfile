FROM debian:stable-slim AS builder
ARG TORVER=0.4.8.10\
    CompilerThreads=4

RUN apt-get  update && apt-get upgrade -y && apt-get install -y build-essential libssl-dev liblzma-dev libzstd-dev libcap-dev liblzma-dev libzstd-dev libcap-dev libevent-dev zlib1g-dev openssl pkg-config python3 wget sudo &&\
    wget https://dist.torproject.org/tor-$TORVER.tar.gz &&\
    tar xzf tor-$TORVER.tar.gz  &&\
    cd tor-$TORVER &&\
    ./configure && make -j $CompilerThreads &&\
    make install

FROM debian:stable-slim
LABEL VERSION=${TORVER}
ARG EXPOSEPORT=9050
ENV UNAME="debian-tor"\
    UID="1000"\
    GID="1000"\
    Nickname="nickname"\
    ContactInfo="Random Person <nobody AT example dot com>"\
    RelayBandwidthRate="100 KB"\
    RelayBandwidthBurst="200 KB"\
    ORPortAdv="4431"\
    ORPortListen="${EXPOSEPORT}"\
    ExitRelay="0"\
    SocksPort="0"\
    DataDirectory="/usr/local/etc/tor/"\
    Log="notice stderr"

VOLUME /usr/local/etc/tor/
EXPOSE ${EXPOSEPORT}

COPY --from=builder /usr/local/bin/tor* /usr/local/bin/
COPY --from=builder /usr/local/share/tor/ /usr/local/share/tor/
COPY entrypoint.sh /
RUN apt-get update && apt-get install -y sudo libevent-2* libcap2 openssl && apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    mkdir -p /usr/local/etc/tor/

ENTRYPOINT  ["/entrypoint.sh"]
