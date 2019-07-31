{
  Release_URL=$(curl -L https://api.github.com/repos/EtherDream/jsproxy/tags | grep zipball_url | cut -d$'\n' -f1 | cut -d'"' -f4)
  echo 11111
  wget -o jsproxy.tar.gz $Release_URL
  tar -xzvf jsproxy.tar.gz
  rm -f jsproxy.tar.gz
  echo 22222
  wget -o jsproxy.tar.gz $Release_URL
  tar -xf jsproxy.tar.gz
  rm -f jsproxy.tar.gz
  echo 33333
  wget -o jsproxy.tar.gz $Release_URL
  tar -xfvw jsproxy.tar.gz
  rm -f jsproxy.tar.gz
}
