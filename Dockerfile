FROM owncloudops/nginx:latest@sha256:824312c3fc3e0f0786beb55a5a2703cb802372fbb5995c4efc9823e2d679a415

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.title="LimeSurvey"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/limesurvey"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/limesurvey"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/limesurvey"

ARG BUILD_VERSION

# renovate: datasource=github-tags depName=LimeSurvey/LimeSurvey
ENV SURVEY_VERSION="${BUILD_VERSION:-5.3.15+220519}"

ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php-fpm8 php"

ADD overlay/ /

RUN apk --update add --virtual .build-deps tar curl composer patch && \
    apk --update add php8 php8-curl php8-fpm php8-gd php8-intl php8-zip php8-xml php8-simplexml php8-xmlreader php8-xmlwriter \
    php8-dom php8-ctype php8-fileinfo php8-tokenizer php8-session php8-ldap php8-json php8-iconv php8-pdo_sqlite php8-pdo_mysql \
    php8-xsl php8-mbstring php8-imap php8-sodium gnu-libiconv && \
    rm -rf /var/www/localhost && \
    rm -f /etc/php8/php-fpm.d/www.conf && \
    mkdir -p /var/www/app/ && \
    SURVEY_VERSION="${SURVEY_VERSION##v}" && \
    echo "Installing limesurvey version '${SURVEY_VERSION}' ..." && \
    curl -SsL "https://github.com/LimeSurvey/LimeSurvey/archive/${SURVEY_VERSION}.tar.gz" | \
        tar xz -C /var/www/app/ -X /.tarignore --strip-components=1 && \
    curl -SsL -o /etc/php8/browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI && \
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
    chown nginx /etc/php8/php.ini && \
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
