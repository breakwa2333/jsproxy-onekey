{
  Release_URL=$(curl -L https://api.github.com/repos/v2ray/v2ray-core/tags | grep zipball_url | cut -d$'\n' -f1 | cut -d'"' -f4)
  wget -o jsproxy.tar.gz $Release_URL
  tar -xzvf jsproxy.tar.gz
  rm -f jsproxy.tar.gz
}
