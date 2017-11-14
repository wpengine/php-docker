# PHP Docker Images

These docker images provide each major version of PHP (currently 5.6, 7.0 and 7.1) with support for various extensions required for WordPress and the WP Engine Platform.

There are three main groups of images provided here:
 - Alpine
 - Busybox
 - Debian
 
The Alpine images are based on the precompiled php-fpm-alpine images available at https://hub.docker.com/_/php/. The gcc library used by Alpine is `musl` (instead of glibc) and all extensions used must be able to compile using musl as well. Currently, ionCube does not provide a musl-based extension which created the need for an alternative set of images using glibc.

The Busybox images are compiled from source downloaded from PHP.net. The library used is glibc which allows the ionCube extension (and any other glibc-only extensions) to work.

The Debian images are based on the precompiled php-fpm-debian images available at https://hub.docker.com/_/php/. The library used is glibc which allows the ionCube extension (and any other glibc-only extensions) to work.

# Updates & Prebuilt Images

These images are configured as Automated builds on [Docker Cloud](https://cloud.docker.com/app/wpengine/repository/docker/wpengine/php).

# Running

By default, this will run php-fpm and listen for FastCGI connections on port 9000.

    docker run -d -p 9000:9000 wpengine/php:7.0-busybox

# Building

## Alpine (musl)
    ./build.sh 5.6 alpine
    ./build.sh 7.0 alpine
    ./build.sh 7.1 alpine
## Busybox (glibc)
    ./build.sh 5.6 busybox
    ./build.sh 7.0 busybox
    ./build.sh 7.1 busybox

## Debian (glibc)
    ./build.sh 5.6 debian
    ./build.sh 7.0 debian
    ./build.sh 7.1 debian

The default build type is `debian`.

OR 

docker build -t wpengine/php:$VERSION-$BASE_IMAGE -f Dockerfile.php$VERSION.$BASE_IMAGE .

### _For alpine:_

    docker build -t wpengine/php:7.0-alpine -f Dockerfile.php7.0.alpine .

### _For busybox:_

    docker build -t wpengine/php:7.0-busybox -f Dockerfile.php7.0.busybox .

### _For debian:_

    docker build -t wpengine/php:7.0-debian -f Dockerfile.php7.0.debian .

# Configuration Files

Before using any of these images in production, be sure to override the default configs found in the following locations. The default values are intended for development and testing, not production deployment.

### php-fpm
```
/usr/local/etc/php-fpm.conf
/usr/local/etc/php-fpm.d/www.conf
```
### php.ini
```
/usr/local/etc/php/php.ini
```
### Extensions
```
/usr/local/etc/php/conf.d/{extension_name}.ini
```

# New Relic

As part of this container we install latest version of the New Relic php agent. The New Relic daemon should be run in a separate container and the daemon socket should be mounted on /run/newrelic/newrelic.sock.  The socket location can be changed by setting newrelic.daemon.port.

```
RUN echo "newrelic.daemon.port=/run/newrelic/newrelic.sock" >> /usr/local/etc/php/conf.d/newrelic.ini
```
