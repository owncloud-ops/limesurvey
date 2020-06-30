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

LIME_ADMIN_MAIL=admin@example.com
LIME_ADMIN_PASSWORD=****
LIME_TRUSTED_HOSTS="localhost,127.0.0.1"

LIME_DATABASE_URL="sqlite:////var/www/app/var/data/LIME.sqlite"
LIME_DB_NAME="limesurvey"
LIME_DB_ROOT_USER=root
LIME_DB_ROOT_PASSWORD=****

LIME_MAILER_FROM=lime@example.com
LIME_MAILER_URL="null://localhost"
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/limesurvey/blob/master/LICENSE) file for details.