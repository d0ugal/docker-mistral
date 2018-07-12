# Docker Mistral

Tools for quickly getting Mistral up and running with Docker and Docker compose.

## Build and Up

```
docker-compose build;
docker-compose up;
```

## Customise Build

By setting some environment variables it is possible to change the Mistral
version that is installed

### Install a specific version

```
MISTRAL_VERSION="7.0.0.0b2" docker-compose build;
```

### Install a Gerrit review

NOTE: This only works for mistral, not mistral-lib or mistralclient

```
GERRIT_REVIEW="581059" docker-compose build;
```
