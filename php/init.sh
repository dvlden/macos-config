#!/usr/bin/env bash

### Include functions
source "$DOT_DIR/lib/functions.sh"

if [ -f '/usr/local/etc/apache2/2.4/httpd.conf' ]; then
    modify_file 'php5_module' \
        'LoadModule php7_module /usr/local/opt/php71/libexec/apache2/libphp7.so' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    modify_line 'DirectoryIndex index.html' \
        'DirectoryIndex index.php index.html' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    uncomment_line 'rewrite_module' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    uncomment_line 'vhost_alias_module' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    uncomment_line 'httpd-vhosts' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    modify_line 'User _www' \
        'User nn' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    modify_line 'Group _www' \
        'Group staff' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    modify_line 'DocumentRoot \"/Library/WebServer/Documents\"' \
        'DocumentRoot \"/Users/nn/Sites\"' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    modify_line '<Directory \"/Library/WebServer/Documents\">' \
        '<Directory \"/Users/nn/Sites\">' \
        '/usr/local/etc/apache2/2.4/httpd.conf'

    modify_line 'ServerName www.example.com:80' \
        'ServerName localhost:80' \
        '/usr/local/etc/apache2/2.4/httpd.conf'
fi

mkdir -p ~/Sites && echo "<?php phpinfo();" > ~/Sites/info.php

# Rewrite the config file
sudo tee '/usr/local/etc/apache2/2.4/extra/httpd-vhosts.conf' <<EOF
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot "/Users/nn/Sites/"
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.dev
    UseCanonicalName Off
    VirtualDocumentRoot "/Users/nn/Sites/%1"
</VirtualHost>

<VirtualHost *:80>
    ServerAlias *.app
    UseCanonicalName Off
    VirtualDocumentRoot "/Users/nn/Sites/%1/public"
</VirtualHost>
EOF

execute 'sudo apachectl -e info -k restart' \
    'Restarting Apache (httpd)'
