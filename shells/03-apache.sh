#!/usr/bin/env bash

echo "=> Apache"


DIR=$(echo /usr/local/etc/httpd)
CONFIG=$(echo $DIR/httpd.conf)
CONFIG_VHOSTS=$(echo $DIR/extra/httpd-vhosts.conf)
CONFIG_SSL=$(echo $DIR/extra/httpd-ssl.conf)


print_info "Configuring core..."

if ! grep -Fxq "$CONFIGURED_MESSAGE" "$CONFIG"
then
  sudo apachectl stop >/dev/null
  sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

  prepend_string_to_file "$CONFIGURED_MESSAGE" "$CONFIG"

  modify_file 'LoadModule rewrite_module' \
    'LoadModule php7_module /usr/local/opt/php/lib/httpd/modules/libphp7.so' \
    "$CONFIG"
    
  uncomment_line 'socache_shmcb_module' "$CONFIG"

  uncomment_line 'ssl_module' "$CONFIG"

  uncomment_line 'rewrite_module' "$CONFIG"

  uncomment_line 'vhost_alias_module' "$CONFIG"

  uncomment_line 'httpd-vhosts' "$CONFIG"
  
  uncomment_line 'httpd-ssl' "$CONFIG"

  uncomment_line 'ServerName www.example.com:8080' "$CONFIG"

  modify_line 'ServerName www.example.com:8080' "ServerName localhost" "$CONFIG"

  modify_line 'Listen 8080' "Listen 80" "$CONFIG"

  modify_line 'User _www' "User $USER" "$CONFIG"

  modify_line 'Group _www' 'Group staff' "$CONFIG"

  modify_line '/usr/local/var/www' "/Users/$USER/Sites" "$CONFIG"

  modify_line 'DirectoryIndex index.html' 'DirectoryIndex index.php index.html' "$CONFIG"

  PHP_APP_HANDLER='<FilesMatch \\.php$>SetHandler application/x-httpd-php</FilesMatch>'
  insert_to_file_after_line_number "$PHP_APP_HANDLER" '286' "$CONFIG"

  sed -i '' '271s/.*/AllowOverride All/' "$CONFIG"

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

<VirtualHost *:443>
    ServerName localhost
    DocumentRoot ${PATH}

    SSLEngine On
    SSLCertificateFile "/Users/${USER}/.ssl/localhost.pem"
    SSLCertificateKeyFile "/Users/${USER}/.ssl/localhost-key.pem"
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.test
    UseCanonicalName Off
    VirtualDocumentRoot "\${PATH}/%1"
</VirtualHost>

<VirtualHost *:443>
    ServerAlias *.secure.test
    UseCanonicalName Off
    VirtualDocumentRoot "${PATH}/%1"

    SSLEngine On
    SSLCertificateFile "/Users/${USER}/.ssl/_wildcard.secure.test.pem"
    SSLCertificateKeyFile "/Users/${USER}/.ssl/_wildcard.secure.test-key.pem"
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.public
    UseCanonicalName Off
    VirtualDocumentRoot "\${PATH}/%1/public"
</VirtualHost>

<VirtualHost *:443>
    ServerAlias *.secure.public
    UseCanonicalName Off
    VirtualDocumentRoot "${PATH}/%1/public"

    SSLEngine On
    SSLCertificateFile "/Users/${USER}/.ssl/_wildcard.secure.public.pem"
    SSLCertificateKeyFile "/Users/${USER}/.ssl/_wildcard.secure.public-key.pem"
</VirtualHost>
EOF

  print_success "Completed..."
else
  print_success "Skipping..."
fi

print_info "Configuring ssl..."

if ! grep -Fxq "$CONFIGURED_MESSAGE" "$CONFIG_SSL"
then
  cat > "$CONFIG_SSL" <<EOF
$CONFIGURED_MESSAGE

Listen 443

SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES

SSLHonorCipherOrder on

SSLProtocol all -SSLv3
SSLProxyProtocol all -SSLv3

SSLPassPhraseDialog  builtin

SSLSessionCache        "shmcb:/usr/local/var/run/httpd/ssl_scache(512000)"
SSLSessionCacheTimeout  300
EOF

  print_success "Completed..."
else
  print_success "Skipping..."
fi
