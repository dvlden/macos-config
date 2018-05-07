#!/usr/bin/env bash

echo "=> DNS Masq"


CONFIG=$(echo $(brew --prefix)/etc/dnsmasq.conf)
RESOLVER_DIR=$(echo /etc/resolver)


print_info "Configuring..."

if ! grep -q "$CONFIGURED_MESSAGE" "$CONFIG"
then
  cat > "$CONFIG" <<EOF
$CONFIGURED_MESSAGE
address=/.test/127.0.0.1
address=/.public/127.0.0.1
EOF

  print_success "Completed..."
else
  print_success "Skipping..."
fi


sudo mkdir -p /etc/resolver


print_info "Creating '.test' resolver..."

if [ ! -f "$RESOLVER_DIR/test" ]
then
  sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
  print_success "Completed..."
else
  print_success "Skipping..."
fi


print_info "Creating '.public' resolver..."

if [ ! -f "$RESOLVER_DIR/public" ]
then
  sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/public'
  print_success "Completed..."
else
  print_success "Skipping..."
fi
