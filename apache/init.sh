#!/usr/bin/env bash

### Include functions
source "$DOT_DIR/lib/functions.sh"

### Variables
APACHE_DIR=/usr/local/etc/apache2/*
HTTPD_CONF=$APACHE_DIR"/httpd.conf"
HTTPD_VHOST=$APACHE_DIR"/extra/httpd-vhosts.conf"
USER=$(whoami)

### Do required
if [ -f $HTTPD_CONF ]; then
  echo 'Apache: Modify "httpd.conf" file...'

  modify_file 'LoadModule rewrite_module' \
    'LoadModule php7_module /usr/local/opt/php71/libexec/apache2/libphp7.so' \
    $HTTPD_CONF

  uncomment_line 'rewrite_module' $HTTPD_CONF

  uncomment_line 'vhost_alias_module' $HTTPD_CONF

  uncomment_line 'httpd-vhosts' $HTTPD_CONF

  modify_line 'User daemon' \
    "User $USER" \
    $HTTPD_CONF

  modify_line 'Group daemon' \
    'Group staff' \
    $HTTPD_CONF

  modify_line '/usr/local/var/www/htdocs' \
    "/Users/$USER/Sites" \
    $HTTPD_CONF

  uncomment_line 'ServerName localhost:80' $HTTPD_CONF

  sed -e '262s/AllowOverride None/AllowOverride All/' $HTTPD_CONF | tee $HTTPD_CONF

  insert='<FilesMatch \\.php$> \
      SetHandler application/x-httpd-php \
  </FilesMatch>'
  insert_to_file_after_line_number $insert '277' $HTTPD_CONF
fi

echo 'Apache: Rewrite "httpd-vhost.conf" file...'
cat > $(echo $HTTPD_VHOST) <<EOF
<VirtualHost *:80>
  ServerName localhost
  DocumentRoot "/Users/$USER/Sites/"
</VirtualHost>

<VirtualHost *:80>
  ServerAlias *.dev
  UseCanonicalName Off
  VirtualDocumentRoot "/Users/$USER/Sites/%1"
</VirtualHost>

<VirtualHost *:80>
  ServerAlias *.app
  UseCanonicalName Off
  VirtualDocumentRoot "/Users/$USER/Sites/%1/public"
</VirtualHost>
EOF

echo 'Apache: restart...'
sudo apachectl -e info -k restart
