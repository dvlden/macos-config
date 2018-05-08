#!/usr/bin/env bash

echo "=> Apache"


DIR=$(echo /usr/local/etc/httpd)
CONFIG=$(echo $DIR/httpd.conf)
CONFIG_VHOSTS=$(echo $DIR/extra/httpd-vhosts.conf)


sudo apachectl stop >/dev/null
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null


print_info "Configuring core..."

if ! grep -Fxq "$CONFIGURED_MESSAGE" "$CONFIG"
then
  prepend_string_to_file "$CONFIGURED_MESSAGE" "$CONFIG"

  modify_file 'LoadModule rewrite_module' \
    'LoadModule php7_module /usr/local/opt/php@7.2/lib/httpd/modules/libphp7.so' \
    "$CONFIG"

  uncomment_line 'rewrite_module' "$CONFIG"

  uncomment_line 'vhost_alias_module' "$CONFIG"

  uncomment_line 'httpd-vhosts' "$CONFIG"

  uncomment_line 'ServerName www.example.com:8080' "$CONFIG"

  modify_line 'Listen 8080' "Listen 80" "$CONFIG"

  modify_line 'User _www' "User $USER" "$CONFIG"

  modify_line 'Group _www' 'Group staff' "$CONFIG"

  modify_line '/usr/local/var/www' "/Users/$USER/Sites" "$CONFIG"

  modify_line 'ServerName www.example.com:8080' "ServerName localhost" "$CONFIG"

  sed -e '270s/AllowOverride None/AllowOverride All/' "$CONFIG" | tee "$CONFIG"

  modify_line 'DirectoryIndex index.html' 'DirectoryIndex index.php index.html' "$CONFIG"

  PHP_APP_HANDLER='<FilesMatch \\.php$> SetHandler application/x-httpd-php </FilesMatch>'
  insert_to_file_after_line_number "$PHP_APP_HANDLER" '285' "$CONFIG"

  print_success "Completed..."
else
  print_success "Skipping..."
fi


print_info "Configuring v-hosts..."

if ! grep -Fxq "$CONFIGURED_MESSAGE" "$CONFIG_VHOSTS"
then
  cat > "$CONFIG_VHOSTS" <<EOF
$CONFIGURED_MESSAGE

Define USER $USER
Define PATH "/Users/\${USER}/Sites"

<VirtualHost *:80>
    ServerName localhost
    DocumentRoot \${PATH}
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.test
    UseCanonicalName Off
    VirtualDocumentRoot "\${PATH}/%1"
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.public
    UseCanonicalName Off
    VirtualDocumentRoot "\${PATH}/%1/public"
</VirtualHost>
EOF

  print_success "Completed..."
else
  print_success "Skipping..."
fi
