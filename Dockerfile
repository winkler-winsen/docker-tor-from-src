FROM debian:stable-slim AS builder
ARG TORVER=0.4.7.13
ARG CompilerThreads=4
ARG EXPOSEPORT=9050\
    DataDirectory="/usr/local/etc/tor/"
ENV Nickname="nickname"\
    ContactInfo="Random Person <nobody AT example dot com>"\
    RelayBandwidthRate="100 KB"\
    RelayBandwidthBurst="200 KB"\
    ORPortAdv="4431"\
    ORPortListen="${EXPOSEPORT}"\
    ExitRelay="0"\
    SocksPort="0"\
    Log="notice stderr"
LABEL VERSION=${TORVER}
VOLUME /usr/local/etc/tor/
EXPOSE ${EXPOSEPORT}

RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential libssl-dev liblzma-dev libzstd-dev libcap-dev liblzma-dev libzstd-dev libcap-dev libevent-dev zlib1g-dev openssl pkg-config python3 wget sudo &&\
    wget https://dist.torproject.org/tor-$TORVER.tar.gz &&\
    tar xzf tor-$TORVER.tar.gz  &&\
    cd tor-$TORVER &&\
    ./configure && make -j $CompilerThreads &&\
    make install

FROM debian
COPY --from=builder /usr/local/bin/tor* /usr/local/bin/.
COPY --from=builder /usr/local/share/tor/ /usr/local/share/tor/.
RUN apt-get update && apt-get install -y libevent-2.1-7 libcap2 && apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    mkdir /usr/local/etc/tor/ &&\
    echo "DataDirectory $DataDirectory" > /usr/local/etc/tor/torrc &&\
    echo "Nickname $Nickname" >> /usr/local/etc/tor/torrc &&\
    echo "ContactInfo $ContactInfo" >> /usr/local/etc/tor/torrc &&\
    echo "RelayBandwidthRate $RelayBandwidthRate" >> /usr/local/etc/tor/torrc &&\
    echo "RelayBandwidthBurst $RelayBandwidthBurst" >> /usr/local/etc/tor/torrc &&\
    echo "ORPort $ORPortAdv NoListen" >> /usr/local/etc/tor/torrc &&\
    echo "ORPort $ORPortListen NoAdvertise" >> /usr/local/etc/tor/torrc &&\
    echo "ExitRelay $ExitRelay" >> /usr/local/etc/tor/torrc &&\
    echo "SocksPort $SocksPort" >> /usr/local/etc/tor/torrc &&\
    echo "Log $Log" >> /usr/local/etc/tor/torrc &&\
    useradd -r -m -s /bin/false debian-tor &&\
    chown -R debian-tor:debian-tor /usr/local/bin/tor /usr/local/share/tor/ /usr/local/etc/tor/

USER debian-tor
ENTRYPOINT  ["tor"]

# docker container create --name debtor -v ${PWD}\usr_local_etc_tor\:/usr/local/etc/tor/  #CONTAINERID