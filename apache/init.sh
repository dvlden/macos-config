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

    modify_line 'php5_module' \
        'LoadModule php7_module /usr/local/opt/php71/libexec/apache2/libphp7.so' \
        $HTTPD_CONF

    modify_line 'DirectoryIndex index.html' \
        'DirectoryIndex index.php index.html' \
        $HTTPD_CONF

    uncomment_line 'rewrite_module' $HTTPD_CONF

    uncomment_line 'vhost_alias_module' $HTTPD_CONF

    uncomment_line 'httpd-vhosts' $HTTPD_CONF

    modify_line 'User _www' \
        'User nn' \
        $HTTPD_CONF

    modify_line 'Group _www' \
        'Group staff' \
        $HTTPD_CONF

    modify_line 'DocumentRoot \"/Library/WebServer/Documents\"' \
        'DocumentRoot \"/Users/nn/Sites\"' \
        $HTTPD_CONF

    modify_line '<Directory \"/Library/WebServer/Documents\">' \
        '<Directory \"/Users/nn/Sites\">' \
        $HTTPD_CONF

    modify_line 'ServerName www.example.com:80' \
        'ServerName localhost:80' \
        $HTTPD_CONF
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
