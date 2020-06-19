FROM owncloudops/nginx:latest

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
    org.label-schema.name="Survey" \
    org.label-schema.vendor="ownCloud GmbH" \
    org.label-schema.schema-version="1.0"

ARG BUILD_VERSION=4.3.0+200616
ENV SURVEY_VERSION="${BUILD_VERSION:-4.3.0+200616}"

ENV SURVEY_ADMIN_USER=admin
ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php-fpm7 php"

ADD overlay/ /

RUN apk --update add --virtual .build-deps tar curl composer && \
    apk --update add php7 php7-curl php7-fpm php7-gd php7-intl php7-zip php7-xml php7-simplexml php7-xmlreader php7-xmlwriter \
    php7-dom php7-ctype php7-fileinfo php7-tokenizer php7-session php7-ldap php7-json php7-iconv php7-pdo_sqlite php7-pdo_mysql \
    php7-xsl php7-mbstring gnu-libiconv && \
    rm -rf /var/www/localhost && \
    rm -f /etc/php7/php-fpm.d/www.conf && \
    mkdir -p /var/www/app/ && \
    SURVEY_VERSION="${SURVEY_VERSION##v}" && \
    echo "Installing limesurvey..." && \
    curl -SsL "https://download.limesurvey.org/latest-stable-release/limesurvey${SURVEY_VERSION}.tar.gz" | \
        tar xz -C /var/www/app/ -X /.tarignore --strip-components=1 && \
    curl -SsL -o /etc/php7/browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI && \
    composer -q install --working-dir=/var/www/app --no-dev --optimize-autoloader && \
    composer -q require --working-dir=/var/www/app laminas/laminas-ldap && \
    composer -q clearcache && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /root/.composer/ && \
    mkdir -p /var/run/php && \
    chown -R nginx /var/run/php && \
    mkdir -p /var/lib/php/tmp_upload && \
    mkdir -p /var/lib/php/soap_cache && \
    mkdir -p /var/lib/php/session && \
    chown -R nginx /var/lib/php && \
    chown nginx /etc/php7/php.ini && \
    chown -R nginx:nginx /var/www/app

VOLUME /var/www/app/var

EXPOSE 8080

USER nginx

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR /var/www/app
CMD []