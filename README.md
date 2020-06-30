[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/limesurvey/status.svg)](https://drone.owncloud.com/owncloud-ops/limesurvey)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/limesurvey)

## LimeSurvey

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=1.8 -f Dockerfile -t limesurvey:latest .
```

## Environment Variables

```Shell
LIME_ADMIN_USER=admin

LIME_ADMIN_MAIL=lime-admin@owncloud.com
LIME_ADMIN_PASSWORD=****

LIME_DB_USERNAME=
LIME_DB_PASSWORD=
LIME_DB_HOST=
LIME_DB_DATABASE=limesurvey
LIME_DB_CHARSET=utf8mb4

LIME_MAILER_FROM=lime@example.com
WAITFOR_TIMEOUT=60
LIME_MAILER_URL=
LIME_MAILER_PORT=
LIME_MAILER_USER=
LIME_MAILER_PASSWORD=
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/limesurvey/blob/master/LICENSE) file for details.
