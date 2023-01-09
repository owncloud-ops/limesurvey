FROM owncloudops/nginx:latest@sha256:24563623d6fe925ce033f09491d12e2b1d905984b247305b2166faa7f995d462

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.title="LimeSurvey"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/limesurvey"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/limesurvey"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/limesurvey"

ARG BUILD_VERSION

# renovate: datasource=github-tags depName=LimeSurvey/LimeSurvey
ENV SURVEY_VERSION="${BUILD_VERSION:-5.5.1+230103}"

ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php-fpm81 php"

ADD overlay/ /

RUN apk --update add --virtual .build-deps tar curl composer patch && \
    apk --update add php81 php81-curl php81-fpm php81-gd php81-intl php81-zip php81-xml php81-simplexml php81-xmlreader php81-xmlwriter \
    php81-dom php81-ctype php81-fileinfo php81-tokenizer php81-session php81-ldap php81-json php81-iconv php81-pdo_sqlite php81-pdo_mysql \
    php81-xsl php81-mbstring php81-imap php81-sodium php81-pecl-imagick gnu-libiconv imagemagick && \
    rm -rf /var/www/localhost && \
    rm -f /etc/php81/php-fpm.d/www.conf && \
    mkdir -p /var/www/app/ && \
    SURVEY_VERSION="${SURVEY_VERSION##v}" && \
    echo "Installing limesurvey version '${SURVEY_VERSION}' ..." && \
    curl -SsfL "https://github.com/LimeSurvey/LimeSurvey/archive/${SURVEY_VERSION}.tar.gz" | \
        tar xz -C /var/www/app/ -X /.tarignore --strip-components=1 && \
    curl -SsfL -o /etc/php81/browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI && \
    patch /var/www/app/application/helpers/ldap_helper.php /0001-fix-ldaps.patch && \
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
    chown nginx /etc/php81/php.ini && \
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
