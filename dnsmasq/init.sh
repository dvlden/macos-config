#!/usr/bin/env bash

if [ ! -f $(brew --prefix)/etc/dnsmasq.conf ]; then
  echo 'DNSMasq: copy "dnsmasq.conf.example" file...'
  cp $(brew list dnsmasq | grep /dnsmasq.conf.example$) /usr/local/etc/dnsmasq.conf

  echo 'DNSMasq: add addresses to to "dnsmasq.conf" file...'
  echo 'address=/.dev/127.0.0.1
  address=/.app/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf

  echo 'DNSMasq: start...'
  brew services start dnsmasq

  echo 'DNSMasq: add resolvers...'
  sudo mkdir -p /etc/resolver
  sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
  sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/app'

  echo 'DNSMasq: restart...'
  brew services restart dnsmasq
fi
