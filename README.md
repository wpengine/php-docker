# PHP Docker Images

These images are built directly from source with PHP extensions in use on the WP Engine Platform.

# Updates & Prebuilt Images

These images are configured as Automated builds on [Docker Hub](https://hub.docker.com/r/wpengine/php/).  New automated builds are triggered by updates to the official PHP repo.

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

The default build type is `busybox`.

OR 

### _For alpine:_

    docker build -t wpengine/php:7.0-alpine -f Dockerfile.php7.0.alpine .

### _For busybox:_

    docker build -t wpengine/php:7.0-busybox -f Dockerfile.php.busybox .  \
    --build-arg PHP_VERSION=7.0.22 --build-arg VERSION=7.0 \
    --build-arg PHP_SHA256={...} --build-arg GPG_KEY1={...} \
    --build-arg GPG_KEY2={...} --build-arg PHP_EXT_SUFFIX={...};

Note that the `busybox` version of the dockerfile requires additional `--build-arg` params that can be found in the `.build.sh` file. 

# Configuration Files

### php-fpm
```
/usr/local/etc/php-fpm.conf
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
RUN { \
		echo "newrelic.daemon.port=/run/newrelic/newrelic.sock"; \
	} > /usr/local/etc/php/conf.d/newrelic.ini
```
