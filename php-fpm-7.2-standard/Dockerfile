FROM php:7.2-fpm as build

RUN apt update && \
    apt install -y \
    $PHPIZE_DEPS \
    libbz2-dev \
    libjpeg-dev \
    libpng-dev \
	libwebp-dev \
    libxpm-dev \
	libfreetype6-dev \
	libc-client-dev \
	libkrb5-dev \
    libicu-dev \
	libldap2-dev \
    libmcrypt-dev \
    libpspell-dev \
    libxml2-dev \
	libxslt-dev \
    libsmbclient-dev \
    libssh2-1-dev \
    unzip \
    libaio1 && \
	rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install bz2
RUN docker-php-ext-install calendar
RUN docker-php-ext-install exif
RUN docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-webp-dir --with-xpm-dir --with-freetype-dir
RUN docker-php-ext-install gd
RUN docker-php-ext-install gettext
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-install intl
RUN docker-php-ext-install ldap
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pspell
RUN docker-php-ext-install shmop
RUN docker-php-ext-install soap
RUN docker-php-ext-install sockets
RUN docker-php-ext-install sysvmsg
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sysvshm
RUN docker-php-ext-install wddx
RUN docker-php-ext-install xsl
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip

# Install Pecl extensions
RUN pecl install igbinary
RUN docker-php-ext-enable igbinary
RUN cd /usr/src/ && pecl bundle redis-5.3.7
RUN docker-php-ext-configure /usr/src/redis --enable-redis-igbinary
RUN docker-php-ext-install /usr/src/redis
RUN docker-php-ext-enable redis
RUN rm -rf /usr/src/redis
RUN pecl install smbclient
RUN docker-php-ext-enable smbclient
RUN pecl install ssh2-1.2
RUN docker-php-ext-enable ssh2
RUN pecl install mailparse-3.1.0
RUN docker-php-ext-enable mailparse
RUN pecl install mcrypt-1.0.5
RUN docker-php-ext-enable mcrypt

# Make Oracle folders
RUN mkdir /opt/oracle

# Copy Oracle libraries
ADD instantclient-basic-linux.x64-21.9.0.0.0dbru.zip /opt/oracle
ADD instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip /opt/oracle
ADD instantclient-sqlplus-linux.x64-21.9.0.0.0dbru.zip /opt/oracle
ADD instantclient-tools-linux.x64-21.9.0.0.0dbru.zip /opt/oracle

# Install Oracle instantclient
RUN unzip /opt/oracle/instantclient-basic-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle
RUN unzip /opt/oracle/instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle
RUN unzip /opt/oracle/instantclient-sqlplus-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle
RUN unzip /opt/oracle/instantclient-tools-linux.x64-21.9.0.0.0dbru.zip -d /opt/oracle

# Clear .zip files
RUN rm -rf /opt/oracle/*.zip

# Link tools and libs
RUN ln -s /opt/oracle/instantclient_21_9/sqlplus /usr/bin/sqlplus && \
    ln -s /opt/oracle/instantclient_21_9/sqlldr /usr/bin/sqlldr && \
    ln -sf /opt/oracle/instantclient_21_9/libclntsh.so.21.1 /usr/lib/libclntsh.so && \
	ln -sf /opt/oracle/instantclient_21_9/libclntshcore.so.21.1 /usr/lib/libclntshcore.so && \
    ln -s /opt/oracle/instantclient_21_9/libocci.so.21.1 /usr/lib/libocci.so && \
    ln -s /opt/oracle/instantclient_21_9/libnnz21.so /usr/lib/libnnz21.so && \
    ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2

# Setup Env variables
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_21_9/
ENV ORACLE_HOME /opt/oracle/instantclient_21_9/
ENV ORACLE_BASE /opt/oracle/instantclient_21_9/
ENV TNS_ADMIN /etc/
ENV ELASTIC_APM_SERVICE_NAME PHP

# Setup Oracle extension
RUN echo "instantclient,/opt/oracle/instantclient_21_9/" | pecl install oci8-2.2.0
RUN docker-php-ext-enable oci8
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_21_9,21.9
RUN docker-php-ext-install pdo_oci

#Install Elastic APM agent
ADD apm-agent-php_1.8.1_all.deb /opt
RUN dpkg -i /opt/apm-agent-php_1.8.1_all.deb
RUN rm -f /opt/apm-agent-php_1.8.1_all.deb

# Delete unused packages
RUN apt purge -y \
    $PHPIZE_DEPS \
    libbz2-dev \
    libjpeg-dev \
    libpng-dev \
	libwebp-dev \
    libxpm-dev \
	libfreetype6-dev \
	libc-client-dev \
	libkrb5-dev \
    libicu-dev \
	libldap2-dev \
    libmcrypt-dev \
    libpspell-dev \
    libxml2-dev \
	libxslt-dev \
    libsmbclient-dev \
    libssh2-1-dev \
    unzip && \
    apt autoremove -y && \
    apt clean


FROM php:7.2-fpm

COPY --from=build / /

RUN apt update && \
    apt install -y \
	libx11-6 \
	libxpm4 \
	libjpeg62-turbo \
	libwebp6 \
	libfreetype6 \
	libmcrypt4 \
	libaspell15 \
	libxslt1.1 \
	libsmbclient \
	sendmail \
    wget \
    sox && \
	rm -rf /var/lib/apt/lists/*

# Copy php config
ADD php.ini /usr/local/etc/php
ADD php-fpm.conf /usr/local/etc
ADD www.conf /usr/local/etc/php-fpm.d

# Setup Env variables
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_21_9/
ENV ORACLE_HOME /opt/oracle/instantclient_21_9/
ENV ORACLE_BASE /opt/oracle/instantclient_21_9/
ENV TNS_ADMIN /etc/
ENV ELASTIC_APM_SERVICE_NAME PHP

WORKDIR /var/www