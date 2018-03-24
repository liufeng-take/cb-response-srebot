# Cb Response SREBOT

## Installing

```
sudo su -
HTTP_PROXY=http://proxy.redcanary.core:8888
git clone https://github.com/redcanaryco/cb-response-srebot.git /var/cb-response-srebot
gem install --http-proxy $PROXY bundler

cd /var/cb-response-srebot
bundle install
```