#!/bin/bash

# setting default version to 7.1
VERSION=${1:-7.1}
BASE_IMAGE=${2:-busybox}

echo Building $PHP_VERSION $BASE_IMAGE

docker build -t wpengine/php:$VERSION-$BASE_IMAGE -f Dockerfile.php$VERSION.$BASE_IMAGE .