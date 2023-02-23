# docker-tor-from-src
Create Docker image from [Tor source][1]  based on [debian:stable-slim][2] image.

I've searched a way to run a to middle-guard relay in Docker. 

Thanks to [Jannis Seeman][4] for this great course in Docker [Docker komplett: Vom Anfänger zum Profi (inkl. Kubernetes)][3].


## Docker build arguments
* TORVER: tor source version
* CompilerThreads: CPU threads to use for compiling during build process. Set this to max CPU cores or threads.
* EXPOSEPORT: Port that is exposed to host.

## Environment variables
Please set User ID and Group ID to match existing account in host system for exchange date via volume.
```
UNAME="debian-tor"
UID="1000"
GID="1000"
```
Please see torrc.sample file for detailed explanation.
```
Nickname="nickname"
ContactInfo="Random Person <nobody AT example dot com>"
RelayBandwidthRate="100 KB"
RelayBandwidthBurst="200 KB"
ORPortAdv="4431"
ORPortListen="${EXPOSEPORT}"
ExitRelay="0"
SocksPort="0"
Log="notice stderr"
```

## Docker example:
```sh
docker build --tag debtor .
docker container create --name debtor -e UID=1031 -e GID=100 -v ${PWD}\usr_local_etc_tor\:/usr/local/etc/tor/ -p 4431:9050 debtor
docker container start debtor
```

[1]: https://dist.torproject.org/
[2]: https://hub.docker.com/_/debian/tags?page=1&name=stable-slim
[3]: https://www.udemy.com/share/107ndq3@Y8QTJlBIofD8l3o9UFcctNUKgsCsoMz52zun8h81JCb6OMHm-4In6w129LYG1-fhXg==/
[4]: https://github.com/jannis-seemann
