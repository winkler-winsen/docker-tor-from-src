# docker-tor-from-src
Create Docker image from Tor source

## Docker build arguments
* TORVER: tor source version
* CompilerThreads: CPU threads to use for compiling during build process. Set this to max CPU cores or threads.
* EXPOSEPORT: Port that is exposed to host.

## Environment variables
* Nickname="nickname"
* ContactInfo="Random Person <nobody AT example dot com>"
* RelayBandwidthRate="100 KB"
* RelayBandwidthBurst="200 KB"
* ORPortAdv="4431"
* ORPortListen="${EXPOSEPORT}"
* ExitRelay="0"
* SocksPort="0"
* Log="notice stderr"

## Docker example:
* docker build --tag debtor .
* docker container create --name debtor -v ${PWD}\usr_local_etc_tor\:/usr/local/etc/tor/ debtor
