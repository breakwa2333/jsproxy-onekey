#!/bin/sh
{ # this ensures the entire script is downloaded #

Green="\033[32m" 
Red="\033[31m" 
Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

JSPROXY_VER=master
OPENRESTY_VER=1.15.8.1

SRC_URL=https://raw.githubusercontent.com/breakwa2333/jsproxy-onekey/$JSPROXY_VER
BIN_URL=https://raw.githubusercontent.com/EtherDream/jsproxy-bin/master
ZIP_URL=https://codeload.github.com/EtherDream/jsproxy/tar.gz

SUPPORTED_OS="Linux-x86_64"
OS="$(uname)-$(uname -m)"
USER=$(whoami)

INSTALL_DIR=/home/jsproxy
NGX_DIR=$INSTALL_DIR/openresty

DOMAIN_SUFFIX=(
  xip.io
  nip.io
  sslip.io
)

COLOR_RESET="\033[0m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"

main() {
    echo $(cd `dirname $0` && pwd)
}

} # this ensures the entire script is downloaded #
