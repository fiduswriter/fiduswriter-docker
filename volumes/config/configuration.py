import os

#############################################
# Django settings for Fidus Writer project. #
#############################################

# After copying this file to configuration.py, adjust the below settings to
# work with your setup.

# If you don't want to show debug messages, set DEBUG to False.

DEBUG = True
# SOURCE_MAPS - allows any value used by webpack devtool
# https://webpack.js.org/configuration/devtool/
# For example
# SOURCE_MAPS = 'cheap-module-source-map' # fast - line numbers only
# SOURCE_MAPS = 'source-map' # slow - line and column number
SOURCE_MAPS = False

PROJECT_PATH = os.environ.get("PROJECT_PATH", "/fiduswriter")
# SRC_PATH is the root path of the FW sources.
SRC_PATH = os.environ.get("SRC_PATH", "/fiduswriter")

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": os.path.join("/data", "fiduswriter.sql"),
        "CONN_MAX_AGE": 15,
    }
}

# Interval between document saves
# DOC_SAVE_INTERVAL = 1

# Migrate, transpile JavaScript and install required fixtures automatically
# when starting runserver. You might want to turn this off on a production
# server. The default is the opposite of DEBUG

# AUTO_SETUP = False

# This determines whether the server is used for testing and will let the
# users know upon signup know that their documents may disappear.
TEST_SERVER = True
# This is the contact email that will be shown in various places all over
# the site.
CONTACT_EMAIL = "mail@email.com"
# If websockets is running on a non-standard port, add it here:
WS_PORT = False

ADMINS = (("Your Name", "your_email@example.com"),)

# Whether anyone surfing to the site can open an account with a login/password.
REGISTRATION_OPEN = True

# Whether user's can login using passwords (if not, they will only be able to
# sign in using social accounts).
PASSWORD_LOGIN = True

# Whether anyone surfing to the site can open an account or login with a
# socialaccount.
SOCIALACCOUNT_OPEN = True

ACCOUNT_EMAIL_VERIFICATION = 'optional'

# This determines whether there is a star labeled "Free" on the login page
IS_FREE = True

MANAGERS = ADMINS

INSTALLED_APPS = [
    "book",
    "citation_api_import",
    "pandoc",
    # "pandoc_on_server"
    # "gitrepo_export",
    # "languagetool",
    # "ojs",
    # "phplist",
    # "payment",
    # "website"
    # If you want to enable one or several of the social network login options
    # below, make sure you add the authorization keys at:
    # http://SERVER.COM/admin/socialaccount/socialapp/
    # 'allauth.socialaccount.providers.facebook',
    # 'allauth.socialaccount.providers.google',
    # 'allauth.socialaccount.providers.twitter',
    # 'allauth.socialaccount.providers.github',
    # 'allauth.socialaccount.providers.linkedin',
    # 'allauth.socialaccount.providers.openid',
    # 'allauth.socialaccount.providers.persona',
    # 'allauth.socialaccount.providers.soundcloud',
    # 'allauth.socialaccount.providers.stackexchange',
]

# A list of allowed hostnames of this Fidus Writer installation
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
]

PORTS = [8000]

# Enable/disable the service worker (default is True)
USE_SERVICE_WORKER = True

# The maximum size of user uploaded images in bytes.
MEDIA_MAX_SIZE = 10 * 1024 * 1024  # 10 MB

# Don't share the SECRET_KEY with anyone.
SECRET_KEY = '5vx9556(@55hv4z(4o)-urkb8a1cq+cg86a$49g%vsm2pt+n+z'

# Media files handling
MEDIA_ROOT = os.path.join('/data', 'media')
MEDIA_URL = '/media/'

# Static files handling
STATIC_ROOT = os.path.join(PROJECT_PATH, 'static')
STATIC_URL = '/static/'
