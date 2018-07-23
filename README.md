# Docker Mistral

Tools for quickly getting Mistral up and running with Docker and Docker
compose. This is inspired by the docker work in the Mistral repo, but defaults
to installing a stable version.

However, this project also aims to provide tools for testing and debugging
while potentially being ready for production use.


## Build and Up

```
docker-compose build;
docker-compose up;
```

## Customise Build

By setting some environment variables it is possible to change the Mistral
version that is installed. After running the build you run `docker-compose up`
like normal.

### Install a specific version

You can install specific versions of Mistral, mistral-lib and
python-mistralclient. These values can be anything that pip installs or just
the version number on its own. See for example installing a beta release, a
specific version and installing from a git repo.

```
MISTRAL_VERSION="7.0.0.0b2" docker-compose build;
MISTRAL_CLIENT_VERSION="python-mistralclient==3.6.1"
MISTRAL_LIB_VERSION="git+https://github.com/d0ugal/mistral-lib.git@master"
```

### Install a Gerrit review

NOTE: This only works for mistral, not mistral-lib or mistralclient

```
GERRIT_REVIEW="581059" docker-compose build;
```
