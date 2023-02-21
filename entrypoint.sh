#!/bin/bash
echo "DataDirectory $DataDirectory" > /usr/local/etc/tor/torrc 
echo "Nickname $Nickname" >> /usr/local/etc/tor/torrc 
echo "ContactInfo $ContactInfo" >> /usr/local/etc/tor/torrc 
echo "RelayBandwidthRate $RelayBandwidthRate" >> /usr/local/etc/tor/torrc 
echo "RelayBandwidthBurst $RelayBandwidthBurst" >> /usr/local/etc/tor/torrc 
echo "ORPort $ORPortAdv NoListen" >> /usr/local/etc/tor/torrc &&\
echo "ORPort $ORPortListen NoAdvertise" >> /usr/local/etc/tor/torrc 
echo "ExitRelay $ExitRelay" >> /usr/local/etc/tor/torrc 
echo "SocksPort $SocksPort" >> /usr/local/etc/tor/torrc 
echo "Log $Log" >> /usr/local/etc/tor/torrc 

groupadd -g $GID -o $UNAME
useradd -M -u $UID -g $GID -o -s /bin/false $UNAME

chown -R $UNAME:$UNAME /usr/local/bin/tor* /usr/local/share/tor/ /usr/local/etc/tor/

sudo -u $UNAME tor
#sudo -u $UNAME bash