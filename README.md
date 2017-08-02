# PHP Docker Images

These images extend the [offical php-fpm images](https://github.com/docker-library/php) with PHP extensions in use on the WP Engine Platform.

# Updates & Prebuilt Images

These images are configured as Automated builds on [Docker Hub](https://hub.docker.com/r/wpengine/php/).  New automated builds are triggered by updates to the official PHP repo.

# Running

By default, this will run php-fpm and listen for FastCGI connections on port 9000.

    docker run -d -p 9000:9000 wpengine/php:7.0

# Building

## Alpine
    ./build.sh 5.6
    ./build.sh 7.0
    ./build.sh 7.1
## Debian
    ./build.sh 5.6-debian
    ./build.sh 7.0-debian
    ./build.sh 7.1-debian
    
OR 
    
    docker build -t wpengine/php:7.0 -f Dockerfile.php7.0 .
    docker build -t wpengine/php:7.0-debian -f Dockerfile.php7.0-debian .

# New Relic

As part of this container we install latest version of the New Relic php agent. The New Relic daemon should be run in a separate container and the daemon socket should be mounted on /tmp/.newrelic.sock.  The socket location can be changed by setting newrelic.daemon.port.

```
RUN { \
		echo "extension=newrelic.so"; \
		echo "newrelic.daemon.port=/var/tmp/newrelic.sock"; \
	} > /usr/local/etc/php/conf.d/docker-php-ext-newrelic.ini
```
