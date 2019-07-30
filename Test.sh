{
A=$(curl -L https://api.github.com/repos/v2ray/v2ray-core/tags | grep zipball_url | cut -d$'\n' -f1 | cut -d'"' -f4)
echo $A
}
