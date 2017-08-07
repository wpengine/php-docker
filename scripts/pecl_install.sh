#!/bin/sh

SOURCE=/usr/src/php-$PHP_VERSION

cd $SOURCE/pecl
pecl download $1-$2
tar zxvf $1*.tgz
rm *.tgz
mv $1-* ../ext/$1
cd ../ext/$1
phpize
./configure
make
