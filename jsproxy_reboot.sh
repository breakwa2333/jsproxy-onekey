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

INSTALL_DIR=/home/jsproxy
NGX_DIR=$INSTALL_DIR/openresty

COLOR_RESET="\033[0m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"

main(){
  iptables -t nat -A PREROUTING -p tcp --dport ${port} -j REDIRECT --to-ports 8443
  su jsproxy -c "bash /home/jsproxy/server/run.sh" 
}

} # this ensures the entire script is downloaded #
