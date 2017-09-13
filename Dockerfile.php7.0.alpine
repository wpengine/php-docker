FROM php:7.0-fpm-alpine

RUN apk add --no-cache \
		bash \
		sed

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		autoconf \
		build-base \
		bzip2-dev \
		gettext-dev \
		icu-dev \
		imagemagick-dev \
		imap-dev \
		libjpeg-turbo-dev \
		libmcrypt-dev \
		libmemcached-dev \
		libpng-dev \
		libssh2-dev \
		libtool \
		libxml2-dev \
		libxslt-dev \
		openldap-dev \
		pcre-dev \
	; \
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install \
		bcmath \	
		bz2 \
		calendar \
		dba \
		exif \
		gd \
		gettext \
		imap \
		intl \
		ldap \
		mcrypt \
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
		igbinary \
		imagick \
		memcached \
		msgpack \
		redis \
	; \
	echo "\n" | pecl install ssh2-1.0; \
	docker-php-ext-enable --ini-name pecl.ini \
		igbinary \
		imagick \
		memcached \
		msgpack \
		redis \
		ssh2 \
	; \
	runDeps="$( \
		scanelf --needed --nobanner --recursive \
			/usr/local/lib/php/extensions \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)"; \
	apk add --virtual .wordpress-phpexts-rundeps $runDeps; \
	apk del .build-deps; \
	rm -rf /tmp/pear/;

RUN set -ex; \
	\
	NR_VERSION="$( \
		curl --connect-timeout 10 -sS https://download.newrelic.com/php_agent/release/ \
			| sed -n 's/.*>\(.*linux-musl\).tar.gz<.*/\1/p' \
	)"; \
	curl --connect-timeout 10 -o nr.tar.gz -fSL "https://download.newrelic.com/php_agent/release/$NR_VERSION.tar.gz"; \
	tar -xf nr.tar.gz; \
	cp $NR_VERSION/agent/x64/newrelic-20151012.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/newrelic.so; \
	mkdir -p /var/log/newrelic; \
	rm -rf newrelic-php5* nr.tar.gz; \
	{ \
		echo "extension=newrelic.so"; \
	} > /usr/local/etc/php/conf.d/docker-php-ext-newrelic.ini

COPY php.ini /usr/local/etc/php/conf.d/php.ini
