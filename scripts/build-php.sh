#!/bin/bash

PHP_INI_DIR=/usr/local/etc/php

mkdir -p $PHP_INI_DIR/conf.d

apt-get update && apt-get install -y --no-install-recommends \
        autoconf build-essential ca-certificates curl dirmngr dpkg-dev file g++ gcc gettext gnupg2 jq \
        libbsd-dev libbz2-dev libc-client2007e-dev libc-dev libcurl3 libcurl3-dev libcurl4-openssl-dev \
        libedit-dev libedit2 libicu-dev libjpeg-dev libkrb5-dev libldap2-dev libmagick++-dev \
        libmagickwand-dev libmcrypt-dev libmemcached-dev libpcre3-dev libpng-dev libsqlite3-0 \
        libsqlite3-dev libssh2-1-dev libssl-dev libtinfo-dev libtool libxml2 libxml2-dev libxslt1-dev \
        make mlocate pax-utils pkg-config re2c wget xz-utils zlib1g-dev;

# Fix for missing library, required later during php configure/make.
cp /usr/lib/libc-client.so.2007e.0 /usr/lib/x86_64-linux-gnu/libc-client.a

# Build and install core PHP
mkdir -p /usr/src
cd /usr/src

# Find out from PHP.net what the latest stable release info is
curl -o php.json http://php.net/releases/active.php

# VERSION is 5.6, 7.0 or 7.1
# Grab the first digit to get the major version
MAJOR=`echo $VERSION | cut -c1`

# Parse the JSON from PHP.net
# Get the JSON block for the current version
PHP_JSON=`cat php.json | \
  jq --arg MAJOR "$MAJOR" '.[$MAJOR]' -r | \
  jq --arg VERSION "$VERSION" '.[$VERSION]' -r`
# Parse the current stable version
PHP_VERSION=`echo $PHP_JSON | jq '.version' -r`
# Parse the sha256 hash for the download verification
PHP_SHA256=`echo $PHP_JSON | jq '.source[] | select(.filename | endswith("xz")) | .sha256' -r`

PHP_EXT_PATH=/usr/local/lib/php/extensions/no-debug-non-zts-$PHP_EXT_SUFFIX
PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
PHP_CPPFLAGS="$PHP_CFLAGS"
PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"
PHP_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror"
PHP_ASC_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror"

# Download and verify PHP source
wget -O php.tar.xz "$PHP_URL"

if [ -n "$PHP_SHA256" ]; then
        echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -
fi

if [ -n "$PHP_ASC_URL" ]; then
        wget -O php.tar.xz.asc "$PHP_ASC_URL"
        export GNUPGHOME="$(mktemp -d)"
        for key in $GPG_KEYS; do
                gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"
        done;
        gpg --batch --verify php.tar.xz.asc php.tar.xz
        rm -rf "$GNUPGHOME"
fi
tar Jxvf php.tar.xz
rm php.tar.xz.asc php.tar.xz
mv php-$PHP_VERSION php
cd /usr/src/php/
ADDITIONAL_OPTIONS=''
if [ $VERSION = "5.6" ]; then ADDITIONAL_OPTIONS="--with-mysql"; fi;
./configure --build="x86_64-linux-gnu" --enable-fpm --enable-static --disable-shared \
--with-fpm-user=www-data --with-fpm-group=www-data --with-config-file-path="$PHP_INI_DIR" \
--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" --with-bz2 --enable-bcmath \
--enable-calendar --enable-dba --enable-exif --enable-ftp --with-gd --with-gettext \
--with-kerberos --with-openssl --with-imap=/usr/lib --with-imap-ssl --with-png-dir=/usr \
--with-jpeg-dir=/usr --enable-intl --with-ldap --with-mcrypt --with-mysqli --with-pdo-mysql \
--enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem \
--enable-sysvshm --enable-wddx --with-xmlrpc --with-xsl --enable-zip --enable-mbstring \
--enable-mysqlnd --with-curl --with-libedit --with-openssl --with-zlib --with-pcre-regex=/usr \
--with-libdir="lib/x86_64-linux-gnu" $ADDITIONAL_OPTIONS;
make -j "$(nproc)"
make install

# Build and install pecl modules
mkdir pecl
cd pecl
for ext in $PECL_MODULES; do 
        pecl download $ext
        tar zxvf $ext.tgz
        cd $ext; phpize; ./configure; make; make install; cd ..;
        rm -Rf $ext*
done

cd /usr/src/php/

# Download the ioncube loader extension
curl --connect-timeout 10 -o ioncube.tar.gz -fSL "https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz"
tar -zxvf ioncube.tar.gz
cp ioncube/ioncube_loader_lin_$VERSION.so $PHP_EXT_PATH/ioncube.so
rm -Rf ioncube*

# Download the New Relic extension
NR_VERSION="$( \
        curl --connect-timeout 10 -sS https://download.newrelic.com/php_agent/release/ \
                | sed -n 's/.*>\(.*linux\).tar.gz<.*/\1/p' \
)";
curl --connect-timeout 10 -o nr.tar.gz -fSL "https://download.newrelic.com/php_agent/release/$NR_VERSION.tar.gz"
tar -xf nr.tar.gz
cp $NR_VERSION/agent/x64/newrelic-$PHP_EXT_SUFFIX.so $PHP_EXT_PATH/newrelic.so
rm -rf newrelic-php5* nr.tar.gz

# Gather required runtime files from installed locations and copy them
# to the .deploy folder which will serve as the new root folder for the 
# final image.
CONF_DIR=usr/local/etc/php/conf.d

mkdir -p .deploy
cd .deploy
# Make the directories we will need at runtime
mkdir -p usr/local/bin usr/local/sbin usr/lib usr/local/include/php/main ./$PHP_EXT_PATH $CONF_DIR
mkdir -p var/lib/php/sessions var/lib/php/opcache run/php usr/local/var/log
echo "[global]" > usr/local/etc/php-fpm.conf
echo "include=etc/php-fpm.d/*.conf" >> usr/local/etc/php-fpm.conf
cp /usr/local/sbin/php-fpm usr/local/sbin/.
cp /usr/local/include/php/main/php_version.h usr/local/include/php/main/.
cp $PHP_EXT_PATH/*.so .$PHP_EXT_PATH/.
# Use the default configs provided by the build. Downstream containers can overwrite
# these as needed.
cp /usr/src/php/php.ini-development usr/local/etc/php/php.ini

# Put the php-fpm and php binaries in the core runtime dependencies list
echo "/usr/local/sbin/php-fpm" > .rundepscore
find $PHP_EXT_PATH -name *.so >> .rundepscore

# Generate the .rundeps file
scandeps.sh

# Grab all the dependencies and toss them in the /usr/lib/ folder.
for f in $(cat .rundeps)
        do cp $f usr/lib/.
done

# Activate additional modules by default
for ext in $PECL_MODULES; do
        ext_name=$(echo $ext | sed 's/-.*//g')
        echo "extension=$ext_name.so" > $CONF_DIR/$ext_name.ini
        if [ $ext_name = "runkit" ]; then
                echo "runkit.internal_override=1" >> $CONF_DIR/runkit.ini
        fi
        if [ $ext_name = "uopz" ]; then
                echo "uopz.enable_exit=1" >> $CONF_DIR/uopz.ini
        fi
done

for ext in opcache ioncube; do
        echo "zend_extension=$ext.so" > $CONF_DIR/$ext.ini
done

echo "opcache.max_accelerated_files=50000" >> $CONF_DIR/opcache.ini
echo "extension=newrelic.so" > $CONF_DIR/newrelic.ini
echo "newrelic.daemon.port=/run/newrelic/newrelic.sock" >> $CONF_DIR/newrelic.ini
