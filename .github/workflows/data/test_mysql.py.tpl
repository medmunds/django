import django
import os

from test_sqlite import *  # NOQA

# The DB user must have all privileges (including create database) on
# 'test_django' and 'test_other'. See
# https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/unit-tests/#using-another-settings-module
# TODO: Could running with root MySQL user could mask problems?
#   (It's much simpler for CI.)
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "django",
        "HOST": "127.0.0.1",
        "USER": "root",
        "PASSWORD": "root_password",
    },
    "other": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "django2",
        "HOST": "127.0.0.1",
        "USER": "root",
        "PASSWORD": "root_password",
    },
}

# TODO: From Jenkins runners. Is this still relevant?
if django.VERSION < (5, 2):
    for name in DATABASES:
        DATABASES[name]["CHARSET"] = "utf8"
        DATABASES[name]["COLLATION"] = "utf8_general_ci"
elif "mariadb" in os.getenv("BUILD_NAME", "").lower():
    # MariaDB still uses latin1 as default charset, but many distros/docker
    # images switch it to utf8mb4 (so might be unnecessary).
    for name in DATABASES:
        DATABASES[name]["CHARSET"] = "utf8mb4"
        DATABASES[name]["COLLATION"] = "utf8mb4_general_ci"
