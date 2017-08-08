#!/bin/bash
CONF_DIR=usr/local/etc/php/conf.d;

cd /usr/src/php-$PHP_VERSION;
mkdir -p .deploy;
cd .deploy;
mkdir -p usr/local/bin usr/local/sbin usr/lib usr/local/include/php/main ./$PHP_EXT_PATH $CONF_DIR;
cp /usr/local/sbin/php-fpm usr/local/sbin/.;
cp /usr/local/bin/php usr/local/bin/.;
cp /usr/local/include/php/main/php_version.h usr/local/include/php/main/.;
cp $PHP_EXT_PATH/*.so .$PHP_EXT_PATH/.;

# Put the php-fpm and php binaries in the core runtime dependencies list
echo "/usr/local/sbin/php-fpm" > .rundepscore;
echo "/usr/local/bin/php" >> .rundepscore;
find $PHP_EXT_PATH -name *.so >> .rundepscore;

# Generate the .rundeps file
scandeps.sh;

# Grab all the dependencies and toss them in the /usr/lib/ folder.
for f in $(cat .rundeps);
    do cp $f usr/lib/.;
done;

# Activate additional modules by default
for ext in $PECL_MODULES; do
    ext_name=$(echo $ext | sed 's/-.*//g');
    echo "extension=$ext_name.so" > $CONF_DIR/$ext_name.ini;
done;

for ext in opcache ioncube; do
    echo "zend_extension=$ext.so" > $CONF_DIR/$ext.ini;
done;
