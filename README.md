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

```
MISTRAL_VERSION="7.0.0.0b2" docker-compose build;
```

This should work with either a specific version, or a range that pip installs.
This means  you can even install from a git repo if it is publicly accessible
on github or similar.

### Install a Gerrit review

NOTE: This only works for mistral, not mistral-lib or mistralclient

```
GERRIT_REVIEW="581059" docker-compose build;
```
