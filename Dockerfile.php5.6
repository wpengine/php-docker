FROM php:5.6-fpm as builder

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
        autoconf \
        build-essential \
        libbsd-dev \
        libbz2-dev \
        libc-client2007e-dev \
        libc6-dev \
        libcurl3 \
        libcurl4-openssl-dev \
        libedit-dev \
        libedit2 \
        libgmp-dev \
        libgpgme11-dev \
        libicu-dev \
        libjpeg-dev \
        libkrb5-dev \
        libldap2-dev \
        libldb-dev \
        libmagick++-dev \
        libmagickwand-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpcre3-dev \
        libpng-dev \
        libsqlite3-0 \
        libsqlite3-dev \
        libssh2-1-dev \
        libssl-dev \
        libtinfo-dev \
        libtool \
        libvpx-dev \
        libwebp-dev \
        libxml2 \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include; \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu; \
    docker-php-ext-configure gd \
        --with-png-dir=/usr \
        --with-jpeg-dir=/usr \
        --with-freetype-dir=/usr \
        --with-xpm-dir=/usr \
        --with-vpx-dir=/usr; \
    docker-php-ext-configure gmp --with-libdir=lib/x86_64-linux-gnu; \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install \
        bcmath \
        bz2 \
        calendar \
        dba \
        exif \
        gd \
        gettext \
        gmp \
        imap \
        intl \
        ldap \
        mcrypt \
        mysql \
        mysqli \
        opcache \
        pdo_mysql \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        wddx \
        xmlrpc \
        xsl \
        zip \
    ; \
    pecl install \
        gnupg-1.4.0 \
        igbinary-2.0.1 \
        imagick-3.4.3 \
        memcached-2.2.0 \
        msgpack-0.5.7 \
        redis-3.1.3 \
        runkit-1.0.4 \
    ; \
    echo "\n" | pecl install ssh2-0.13; \
    docker-php-ext-enable --ini-name pecl.ini \
        gnupg \
        igbinary \
        imagick \
        memcached \
        msgpack \
        redis \
        runkit \
        ssh2 \
    ; \
    curl --connect-timeout 10 -o ioncube.tar.gz -kfSL "https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz"; \
    tar -zxvf ioncube.tar.gz; \
    cp ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ioncube.so; \
    rm -Rf ioncube*; \
    NR_VERSION="$( curl --connect-timeout 10 -skS https://download.newrelic.com/php_agent/release/ | sed -n 's/.*>\(.*linux\).tar.gz<.*/\1/p')"; \
    curl --connect-timeout 10 -o nr.tar.gz -kfSL "https://download.newrelic.com/php_agent/release/$NR_VERSION.tar.gz"; \
    tar -xf nr.tar.gz; \
    cp $NR_VERSION/agent/x64/newrelic-20131226.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/newrelic.so; \
    rm -rf newrelic-php5* nr.tar.gz; \
    echo "zend_extension=ioncube.so" > /usr/local/etc/php/conf.d/01-ioncube.ini; \
    echo "extension=newrelic.so" > /usr/local/etc/php/conf.d/10-newrelic.ini; \
    echo "runkit.internal_override=1" > /usr/local/etc/php/conf.d/10-runkit.ini;

# Now that all the modules are built/downloaded, use the original php:5.6-fpm image and
# install only the runtime dependencies with the new modules and config files.
FROM php:5.6-fpm

WORKDIR /

RUN set -ex ; \
    \
    apt-get update && apt-get install -y --no-install-recommends \
        libc-client2007e \
        libgpgme11 \
        libicu57 \
        libmagickwand-6.q16-3 \
        libmcrypt4 \
        libmemcached11 \
        libmemcachedutil2 \
        libpng16-16 \
        libvpx4 \
        libwebp6 \
        libxpm4 \
        libxslt1.1 \
        ssmtp \
        ; \
    rm -rf /tmp/pear /usr/share/doc /usr/share/man /var/lib/apt/lists/*; \
    cd /usr/local/etc/php; \
    php-fpm -v 2>/dev/null | sed -E 's/PHP ([5|7].[0-9]{1,2}.[0-9]{1,2})(.*)/\1/g' | head -n1 > php_version.txt;

COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-20131226/ /usr/local/lib/php/extensions/no-debug-non-zts-20131226/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

RUN pear install --alldeps \
        Auth_SASL \
        Auth_SASL2-beta \
        Benchmark \
        pear.php.net/Console_Color2-0.1.2 \
        Console_Table \
        HTTP_OAuth-0.3.1 \
        HTTP_Request2 \
        Log \
        Mail \
        MDB2 \
        Net_GeoIP \
        Net_SMTP \
        Net_Socket \
        XML_RPC2 \
        pear.symfony.com/YAML \
    ;

RUN set -ex \
    && { \
        echo '[global]'; \
        echo 'daemonize = no'; \
        echo 'error_log = /proc/self/fd/2'; \
        echo; \
        echo '[www]'; \
        echo 'listen = [::]:9000'; \
        echo 'listen.owner = www-data'; \
        echo 'listen.group = www-data'; \
        echo; \
        echo 'user = www-data'; \
        echo 'group = www-data'; \
        echo; \
        echo 'access.log = /proc/self/fd/2'; \
        echo; \
        echo 'pm = static'; \
        echo 'pm.max_children = 1'; \
        echo 'pm.start_servers = 1'; \
        echo 'request_terminate_timeout = 65s'; \
        echo 'pm.max_requests = 1000'; \
        echo 'catch_workers_output = yes'; \
    } | tee /usr/local/etc/php-fpm.d/www.conf \
    && mkdir -p /usr/local/php/php/auto_prepends \
    && { \
        echo '<?php'; \
        echo 'if (function_exists("uopz_allow_exit")) {'; \
        echo '    uopz_allow_exit(true);'; \
        echo '}'; \
        echo '?>'; \
    } | tee /usr/local/php/php/auto_prepends/default_prepend.php \
    && { \
        echo 'FromLineOverride=YES'; \
        echo 'mailhub=127.0.0.1'; \
        echo 'UseTLS=NO'; \
        echo 'UseSTARTTLS=NO'; \
    } | tee /etc/ssmtp/ssmtp.conf \
    && { \
        echo '[PHP]'; \
        echo 'log_errors = On'; \
        echo 'error_log = /dev/stderr'; \
        echo 'auto_prepend_file = /usr/local/php/php/auto_prepends/default_prepend.php'; \
    } | tee /usr/local/etc/php/conf.d/php.ini \
    ;

EXPOSE 9000
CMD ["php-fpm"]
