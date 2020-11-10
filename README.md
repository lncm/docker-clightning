# C-Lightning in a Docker container

## What

C-Lightning by Elements project in a [docker container](https://gitlab.com/nolim1t/docker-clightning)

## Why?

To do cross-platform builds the [LNCM](https://github.com/lncm/) way, like some of my other containers

## Building

### By Default

To simply build this project just invoke (This will build against latest tag)

```bash
docker build -t nolim1t/clightning .
```

### Specifying a version

For example specifying a version to build

```bash
docker build \
    --build-arg VERSION=v0.9.1 \
    -t nolim1t/clightning:v0.9.1 .
```

## Todo

- [ ] Document how to build this project for more advanced users
- [ ] Document how to use this container (config files, etc)
- [ ] Build a docker compose file as an example
- [ ] Build a gitlab action. Gitlab will be the main focus for this project
- [ ] Build a github action. Github will be the secondary focus for this.
