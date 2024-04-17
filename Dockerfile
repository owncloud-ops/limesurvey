FROM docker.io/owncloudops/nginx:latest@sha256:3ba332015d03f8433c28da031c1b7fc96786725aae650670ef9536df7b2f2957

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.title="LimeSurvey"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/limesurvey"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/limesurvey"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/limesurvey"

ARG BUILD_VERSION

# renovate: datasource=github-tags depName=LimeSurvey/LimeSurvey
ENV SURVEY_VERSION="${BUILD_VERSION:-6.5.2+240402}"

ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php-fpm82 php"

ADD overlay/ /

RUN apk --update add --virtual .build-deps tar curl composer patch && \
    apk --update add php82 php82-curl php82-fpm php82-gd php82-intl php82-zip php82-xml php82-simplexml php82-xmlreader php82-xmlwriter \
    php82-dom php82-ctype php82-fileinfo php82-tokenizer php82-session php82-ldap php82-json php82-iconv php82-pdo_sqlite php82-pdo_mysql \
    php82-xsl php82-mbstring php82-imap php82-sodium php82-pecl-imagick gnu-libiconv imagemagick && \
    rm -rf /var/www/localhost && \
    rm -f /etc/php82/php-fpm.d/www.conf && \
    mkdir -p /var/www/app/ && \
    SURVEY_VERSION="${SURVEY_VERSION##v}" && \
    echo "Installing limesurvey version '${SURVEY_VERSION}' ..." && \
    curl -SsfL "https://github.com/LimeSurvey/LimeSurvey/archive/${SURVEY_VERSION}.tar.gz" | \
        tar xz -C /var/www/app/ -X /.tarignore --strip-components=1 && \
    curl -SsfL -o /etc/php82/browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI && \
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
    chown nginx /etc/php82/php.ini && \
    chown -R nginx:nginx /var/www/app && \
    [ -f /usr/bin/php ] || ln -s /usr/bin/php /usr/bin/php82

VOLUME /var/www/app/upload
VOLUME /var/www/app/plugins

EXPOSE 8080

USER nginx

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR /var/www/app
CMD []
