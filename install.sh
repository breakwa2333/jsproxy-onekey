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

output() {
  local color=$1
  shift 1
  local sdata=$@
  local stime=$(date "+%H:%M:%S")
  printf "$color[jsproxy $stime]$COLOR_RESET $sdata\n"
}
log() {
  output $COLOR_GREEN $1
}
warn() {
  output $COLOR_YELLOW $1
}
err() {
  output $COLOR_RED $1
}

gen_cert() {
  local ip=`curl -4 ip.sb`

  if [[ ! $ip ]]; then
    warn "IP 获取失败"
  fi

  if [[ ! $(grep -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" <<< $ip) ]]; then
    warn "无效 IP：$ip"
  fi

  if [[ $ip ]]; then
    log "服务器公网 IP: $ip"
  else
    err "服务器公网 IP 获取失败，无法申请证书"
    exit 1
  fi

  log "安装 acme.sh 脚本 ..."
  curl https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh | INSTALLONLINE=1  sh

  local acme=~/.acme.sh/acme.sh

  if [[ ${1} == "0" ]]; then
    for i in ${DOMAIN_SUFFIX[@]}; do
      local domain=$ip.$i
      log "尝试为域名 $domain 申请证书 ..."

      local dist=server/cert/$domain
      mkdir -p $dist

      $acme \
        --issue \
        -d $domain \
        --keylength ec-256 \
        --webroot server/acme

      $acme \
        --install-cert \
        -d $domain \
        --ecc \
        --key-file $dist/ecc.key \
        --fullchain-file $dist/ecc.cer

      if [ -s $dist/ecc.key ] && [ -s $dist/ecc.cer ]; then
        echo "# generated by install.sh
      listen                8443 ssl http2;
      ssl_certificate       cert/$domain/ecc.cer;
      ssl_certificate_key   cert/$domain/ecc.key;
      " > server/cert/cert.conf
        local url=https://$domain:$2
        echo "$url  'mysite';" >> server/allowed-sites.conf

        log "证书申请完成，重启服务 ..."
        server/run.sh reload

        log "在线预览: $url"
        break
      fi

      err "证书申请失败！"
      rm -rf $dist
    done
  else
      local dist=server/cert/$1
      mkdir -p $dist
      
      $acme \
        --issue \
        -d $1 \
        --keylength ec-256 \
        --webroot server/acme

      $acme \
        --install-cert \
        -d $1 \
        --ecc \
        --key-file $dist/ecc.key \
        --fullchain-file $dist/ecc.cer

      if [ -s $dist/ecc.key ] && [ -s $dist/ecc.cer ]; then
        echo "# generated by install.sh
      listen                8443 ssl http2;
      ssl_certificate       cert/$1/ecc.cer;
      ssl_certificate_key   cert/$1/ecc.key;
      " > server/cert/cert.conf

      local url=https://$1:$2
      echo "$url  'mysite';" >> server/allowed-sites.conf

      log "证书申请完成，重启服务 ..."
      server/run.sh reload

      log "在线预览: $url"
      break
      fi

      err "证书申请失败！"
      rm -rf $dist
  fi
}


install() {
  cd $INSTALL_DIR

  log "下载 nginx 程序 ..."
  curl -O $BIN_URL/$OS/openresty-$OPENRESTY_VER.tar.gz
  tar zxf openresty-$OPENRESTY_VER.tar.gz
  rm -f openresty-$OPENRESTY_VER.tar.gz

  local ngx_exe=$NGX_DIR/nginx/sbin/nginx
  local ngx_ver=$($ngx_exe -v 2>&1)

  if [[ "$ngx_ver" != *"nginx version:"* ]]; then
    err "$ngx_exe 无法执行！尝试编译安装"
    exit 1
  fi
  log "$ngx_ver"
  log "nginx path: $NGX_DIR"

  log "下载代理服务 ..."
  curl -o jsproxy.tar.gz $ZIP_URL/$JSPROXY_VER
  tar zxf jsproxy.tar.gz
  rm -f jsproxy.tar.gz

  log "下载静态资源 ..."
  curl -o www.tar.gz $ZIP_URL/gh-pages
  tar zxf www.tar.gz -C jsproxy-$JSPROXY_VER/www --strip-components=1
  rm -f www.tar.gz

  if [ -x server/run.sh ]; then
    warn "尝试停止当前服务 ..."
    server/run.sh quit
  fi

  if [ -d server ]; then
    backup="$INSTALL_DIR/bak/$(date +%Y_%m_%d_%H_%M_%S)"
    warn "当前 server 目录备份到 $backup"
    mkdir -p $backup
    mv server $backup
  fi

  mv jsproxy-$JSPROXY_VER server

  log "启动服务 ..."
  server/run.sh

  log "服务已开启"
  gen_cert $1 $2
}

main() {
  log "自动安装脚本开始执行"

  if [[ "$SUPPORTED_OS" != *"$OS"* ]]; then
    err "当前系统 $OS 不支持自动安装。尝试编译安装"
    exit 1
  fi

  if [[ "$USER" != "root" ]]; then
    err "自动安装需要 root 权限。如果无法使用 root，尝试编译安装"
    exit 1
  fi

  if ! id -u jsproxy > /dev/null 2>&1 ; then
    log "创建用户 jsproxy ..."
    groupadd nobody > /dev/null 2>&1
    useradd jsproxy -g nobody --create-home
  fi

  warn "HTTPS 证书申请需要验证 80 端口，确保 TCP:80 已添加到防火墙"
  warn "如果当前已有 80 端口的服务，将暂时无法收到数据"
  iptables \
    -m comment --comment "acme challenge svc" \
    -t nat \
    -I PREROUTING 1 \
    -p tcp --dport 80 \
    -j REDIRECT \
    --to-ports 10080
  
  stty iuclc && read -p "请输入域名（default:随机二级域名）:" host
  if [[ -z ${host} ]]; then
    host="0"
    echo -e "${OK} ${GreenBG} 服务域名已设置为随机二级域名 ${Font}"
  else
    echo -e "${OK} ${GreenBG} 服务域名已设置为${host} ${Font}"
    echo -e "${OK} ${GreenBG} 正在获取 域名公网IP 信息，请耐心等待 ${Font}"
    domain_ip=`ping ${host} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
    local_ip=`curl -4 ip.sb`
    echo -e "域名dns解析IP：${domain_ip}"
    echo -e "本机IP: ${local_ip}"
    sleep 2
    if [[ $(echo ${local_ip}|tr '.' '+'|bc) -eq $(echo ${domain_ip}|tr '.' '+'|bc) ]];then
      echo -e "${OK} ${GreenBG} 域名dns解析IP  与 本机IP 匹配 ${Font}"
      sleep 2
    else
      echo -e "${Error} ${RedBG} 域名dns解析IP 与 本机IP 不匹配 是否继续安装？（y/n）${Font}" && read still
      case $still in
      [yY][eE][sS]|[yY])
          echo -e "${GreenBG} 继续安装 ${Font}" 
          sleep 2
          ;;
      *)
          echo -e "${RedBG} 安装终止 ${Font}" 
          exit 2
          ;;
      esac
    fi
  fi
  
  stty iuclc && read -p "请输入服务端口（default:443）:" port
  [[ -z ${port} ]] && port="443"
  iptables -t nat -A PREROUTING -p tcp --dport ${port} -j REDIRECT --to-ports 8443
  echo -e "${OK} ${GreenBG} 服务端口已设置为${port} ${Font}"
  
  echo -e "${OK} ${GreenBG} 正在配置自启动服务 ${Font}"
  wget $SRC_URL/jsproxy_reboot.sh
  echo "# generated by install.sh
      [Unit]
      After=network.target
      
      [Service]
      ExecStart=$(cd `dirname $0` && pwd)/jsproxy_reboot.sh
      
      [Install]
      WantedBy=default.target
      " > /etc/systemd/system/jsproxy.service
  chmod 744 $(cd `dirname $0` && pwd)/jsproxy_reboot.sh
  systemctl daemon-reload
  systemctl enable jsproxy.service
  echo -e "${OK} ${GreenBG} 自启动服务配置完成 ${Font}"

  log "切换到 jsproxy 用户，执行安装脚本 ..."
  su jsproxy -c "curl -L -s dos2unix $SRC_URL/install.sh | bash -s install ${host} ${port}"

  local line=$(iptables -t nat -L --line-numbers | grep "acme challenge svc")
  iptables -t nat -D PREROUTING ${line%% *}

  log "安装完成。后续维护参考 https://github.com/EtherDream/jsproxy"
}


case $1 in
"install")
  install ${2} ${3};;
"cert")
  gen_cert ${2} ${3};;
*)
  main;;
esac

} # this ensures the entire script is downloaded #
