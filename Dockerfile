FROM owncloudops/nginx:latest

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
    org.label-schema.name="Survey" \
    org.label-schema.vendor="ownCloud GmbH" \
    org.label-schema.schema-version="1.0"

# Database migrations work for releases from 4.x.x on upwards. From 4.x.x to 5.x.x testing is neccesary!!!!
# Migrations from 3.x.x to 4.x.x break the underlying yii framework.
ARG BUILD_VERSION=4.3.2+200629
ENV SURVEY_VERSION="${BUILD_VERSION:-4.3.2+200629}"

ENV SURVEY_ADMIN_USER=admin
ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php-fpm7 php"

ADD overlay/ /

RUN apk --update add --virtual .build-deps tar curl composer && \
    apk --update add php7 php7-curl php7-fpm php7-gd php7-intl php7-zip php7-xml php7-simplexml php7-xmlreader php7-xmlwriter \
    php7-dom php7-ctype php7-fileinfo php7-tokenizer php7-session php7-ldap php7-json php7-iconv php7-pdo_sqlite php7-pdo_mysql \
    php7-xsl php7-mbstring php7-imap php7-sodium gnu-libiconv && \
    rm -rf /var/www/localhost && \
    rm -f /etc/php7/php-fpm.d/www.conf && \
    mkdir -p /var/www/app/ && \
    SURVEY_VERSION="${SURVEY_VERSION##v}" && \
    echo "Installing limesurvey version '${SURVEY_VERSION}' ..." && \
    curl -SsL "https://github.com/LimeSurvey/LimeSurvey/archive/${SURVEY_VERSION}.tar.gz" | \
        tar xz -C /var/www/app/ -X /.tarignore --strip-components=1 && \
    curl -SsL -o /etc/php7/browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI && \
    patch /var/www/app/application/helpers/ldap_helper.php /ldap_helper.patch && \
    patch /var/www/app/application/views/admin/survey/topbar/token_bar.php /token_bar.patch && \
    mkdir -p /var/www/app/upload/surveys && \
    mkdir -p /var/www/app/uploadstruct && \
    cp -a /var/www/app/upload/* /var/www/app/uploadstruct && \
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

VOLUME /var/www/app/upload
VOLUME /var/www/app/plugins

EXPOSE 8080

USER nginx

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR /var/www/app
CMD []
