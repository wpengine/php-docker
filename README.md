# PHP Docker Images

These docker images provide each major version of PHP (currently 5.6, 7.0, 7.1 and 7.2) with support for various extensions required for WordPress and the WP Engine Platform.

Images are based on the precompiled php-fpm debian images available at https://hub.docker.com/_/php/. 
# Updates & Prebuilt Images

These images are configured as Automated builds on [Docker Cloud](https://cloud.docker.com/app/wpengine/repository/docker/wpengine/php).

# Running

By default, this will run php-fpm and listen for FastCGI connections on port 9000.

    docker run -d -p 9000:9000 wpengine/php:7.0
# Building

    make build-7.0

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
