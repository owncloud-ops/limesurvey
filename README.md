# limesurvey

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/limesurvey/status.svg)](https://drone.owncloud.com/owncloud-ops/limesurvey)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/limesurvey)
[![Quay.io](https://img.shields.io/badge/quay-latest-blue.svg?logo=docker&logoColor=white)](https://quay.io/repository/owncloudops/limesurvey)

Custom container image for [LimeSurvey](https://www.limesurvey.org/de/).

## Ports

- 8080

## Volumes

- /var/www/app/upload
- /var/www/app/plugins

## Environment Variables

```Shell
LIME_ADMIN_USER=admin
LIME_ADMIN_PASSWORD=
LIME_ADMIN_NAME=Administrator
LIME_ADMIN_EMAIL=your-email@example.com
LIME_ADMIN_BOUNCE=your-email@example.com

LIME_DB_USERNAME=limesurvey
LIME_DB_PASSWORD=limesurvey
LIME_DB_HOST=mariadb
LIME_DB_PORT=3306
LIME_DB_NAME=limesurvey
LIME_DB_CHARSET=utf8mb4

LIME_MAILER_URL=mx.example.com
LIME_MAILER_PORT=465
LIME_MAILER_USER=sender
LIME_MAILER_PASSWORD=
LIME_MAILER_ENCRYPTION=ssl
LIME_MAILER_PROTOCOL=smtp

LIME_ENCRYPTION_KEYPAIR=
LIME_ENCRYPTION_PUBLIC_KEY=
LIME_ENCRYPTION_SECRET_KEY=
LIME_ENCRYPTION_NONCE=
LIME_ENCRYPTION_SECRET_BOX_KEY=

LIME_SSL_DISABLE_ALERT=false

# This variable need to be set to enable LDAP queries
LIME_LDAP_QUERY_SERVER=
LIME_LDAP_QUERY_PORT=389
LIME_LDAP_QUERY_ENCRYPTION=none
LIME_LDAP_QUERY_PROTOVERSION=ldapv2
LIME_LDAP_QUERY_REFERALS=false
LIME_LDAP_QUERY_BINDDN=
LIME_LDAP_QUERY_BINDPW=
LIME_LDAP_QUERY_GROUPLIST=

LIME_LDAP_QUERY_<LIME_LDAP_QUERY_GROUPLIST_ITEM>_NAME=
LIME_LDAP_QUERY_<LIME_LDAP_QUERY_GROUPLIST_ITEM>_USERBASE=
LIME_LDAP_QUERY_<LIME_LDAP_QUERY_GROUPLIST_ITEM>_USERFILTER=(&(objectClass=inetOrgPerson))
LIME_LDAP_QUERY_<LIME_LDAP_QUERY_GROUPLIST_ITEM>_USERSCOPE=sub
LIME_LDAP_QUERY_<LIME_LDAP_QUERY_GROUPLIST_ITEM>_FIRSTNAME_ATTR=givenname
LIME_LDAP_QUERY_<LIME_LDAP_QUERY_GROUPLIST_ITEM>_LASTNAME_ATTR=sn
LIME_LDAP_QUERY_<LIME_LDAP_QUERY_GROUPLIST_ITEM>_EMAIL_ATTR=mail

LIME_DEBUG=0
LIME_DEBUG_SQL=0
```

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=1.8 -f Dockerfile -t kimai2:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/limesurvey/blob/main/LICENSE) file for details.
