[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/limesurvey/status.svg)](https://drone.owncloud.com/owncloud-ops/limesurvey)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/limesurvey)

## LimeSurvey

Custom Docker image for [LimeSurvey](https://www.limesurvey.org/de/).

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=1.8 -f Dockerfile -t limesurvey:latest .
```

## Environment Variables

```Shell
LIME_ADMIN_USER=admin

LIME_ADMIN_MAIL=lime-admin@example.com
LIME_ADMIN_PASSWORD=****

LIME_DB_USERNAME=limesurvey
LIME_DB_PASSWORD=****
LIME_DB_HOST=localhost
LIME_DB_PORT=3306
LIME_DB_DATABASE=limesurvey
LIME_DB_CHARSET=utf8mb4

LIME_MAILER_FROM=lime@example.com
LIME_MAILER_URL=mx.example.com
LIME_MAILER_PORT=465
LIME_MAILER_USER=sender
LIME_MAILER_PASSWORD=****
LIME_MAILER_ENCRYPTION=ssl
LIME_MAIL_PROTOCOL=smtp

LIME_SITENAME=LimeSurvey
LIME_SSL_DISABLE_ALERT=false
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/limesurvey/blob/master/LICENSE) file for details.
