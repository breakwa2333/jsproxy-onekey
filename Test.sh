{
  Release_URL=$(curl -L https://api.github.com/repos/EtherDream/jsproxy/tags | grep zipball_url | cut -d$'\n' -f1 | cut -d'"' -f4)
  echo 11111
  curl -L -o jsproxy.tar.gz $Release_URL
  unzip jsproxy.tar.gz
  rm -f jsproxy.tar.gz
  echo 22222
  curl -L -o jsproxy.tar $Release_URL
  unzip jsproxy.tar
  rm -f jsproxy.tar
  echo 33333
  curl -L -o jsproxy.zip $Release_URL
  unzip jsproxy.zip
  rm -f jsproxy.zip
}
