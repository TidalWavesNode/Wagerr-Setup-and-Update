#!/bin/bash

TMP_FOLDER=$(mktemp -d)
COIN_DAEMON='/usr/local/bin/wagerrd'
COIN_CLI='/usr/local/bin/wagerr-cli'
COIN_REPO='https://github.com/wagerr/wagerr/releases/download/v2.0.1/wagerr-2.0.1-x86_64-linux-gnu.tar.gz'
COIN_NAME='Wagerr'
#COIN_BS='http://bootstrap.zip'

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function update_node() {
  echo -e "Preparing to download updated $COIN_NAME"
  rm /usr/local/bin/wagerr*
  cd $TMP_FOLDER
  wget -q $COIN_REPO
  compile_error
  COIN_ZIP=$(echo $COIN_REPO | awk -F'/' '{print $NF}')
  tar xvf $COIN_ZIP --strip 1 >/dev/null 2>&1
  compile_error
  cp bin/wagerr{d,-cli} /usr/local/bin
  compile_error
  strip $COIN_DAEMON $COIN_CLI
  cd - >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
  chmod +x $COIN_DAEMON
  chmod +x $COIN_CLI
  clear
}

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function checks() {
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi
}

function prepare_system() {
echo -e "Updating the system and the ${GREEN}$COIN_NAME${NC} masternode."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev unzip libgmp3-dev libzmq3-dev ufw pkg-config libevent-dev libdb5.3++>/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev libzmq3-dev ufw fail2ban pkg-config libevent-dev"
 exit 1
fi
systemctl stop $COIN_NAME.service
sleep 3
pkill -9 wagerrd
clear
}

function import_bootstrap() {
  rm -r ~/.wagerr/blocks ~/.wagerr/chainstate ~/.wagerr/peers.dat
  wget -q $COIN_BS
  compile_error
  COIN_ZIP=$(echo $COIN_BS | awk -F'/' '{print $NF}')
  unzip $COIN_ZIP >/dev/null 2>&1
  compile_error
  cp -r ~/bootstrap/blocks ~/.wagerr/blocks
  cp -r ~/bootstrap/chainstate ~/.wagerr/chainstate
  cp -r ~/bootstrap/peers.dat ~/.wagerr/peers.dat
  rm -r ~/bootstrap/
  rm $COIN_ZIP
  echo -e "Sync is complete"
}

function important_information() {
 systemctl start $COIN_NAME.service
 echo
 echo -e "================================================================================================================================"
 echo -e "$COIN_NAME Masternode is updated and running again!"
 echo -e "Start: ${RED}systemctl start $COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $COIN_NAME.service${NC}"
 echo -e "Please check ${RED}$COIN_NAME${NC} is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
}

##### Main #####
clear


checks
prepare_system
update_node
#import_bootstrap
important_information
