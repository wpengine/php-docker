# PHP Docker Images

These images extend the [offical php-fpm images](https://github.com/docker-library/php/blob/76a1c5ca161f1ed6aafb2c2d26f83ec17360bc68/7.1/fpm/alpine/Dockerfile) with PHP extensions in use on the WP Engine Platform. They are based on Alpine Linux.

Updates & Prebuilt Images
---

These images are configured as Automated builds on [Docker Hub](https://hub.docker.com/r/wpengine/php/).  New automated builds are triggered by updates to the official PHP repo.

Running
---

By default, this will run php-fpm and listen for FastCGI connections on port 9000.

    docker run -d -p 9000:9000 wpengine/php:7.0

Building
---

    docker build -t wpengine/php:7.1 -f Dockerfile.php7.1 .
    docker build -t wpengine/php:7.0 -f Dockerfile.php7.0 .
    docker build -t wpengine/php:5.6 -f Dockerfile.php5.6 .
