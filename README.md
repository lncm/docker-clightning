# C-Lightning in a Docker container

[![pipeline status](https://gitlab.com/nolim1t/docker-clightning/badges/master/pipeline.svg)](https://gitlab.com/nolim1t/docker-clightning/-/commits/master)

## What

[C-Lightning](https://github.com/ElementsProject/lightning) by [Elements Project](https://github.com/ElementsProject/) in a [docker container](https://gitlab.com/nolim1t/docker-clightning) for easy orchestration on embedded devices (like the Raspberry Pi), and auto-building.

## Why?

To do cross-platform builds the [LNCM](https://github.com/lncm/) way, like some of my other containers

## Building

### By Default

To simply build this project just invoke (This will build against latest tag)

```bash
docker build -t nolim1t/clightning .
```

### Specifying a version

For example specifying a version to build.


```bash
docker build \
    --build-arg VERSION=v0.9.1 \
    -t nolim1t/clightning:v0.9.1 .
```
The other configurables you can use are:

- `REPO` defines the master repo for lightning (eventually would like to make this fetch from TOR so the whole thing is anonymous)
- `USER` defines the user name (Its cosmetic at this stage)
- `DATA` defines the data folder for lightning user within the container

## Todo

- [x] Document how to build this project for more advanced users
- [ ] Document how to use this container (config files, etc)
- [ ] Build a docker compose file as an example
- [x] Build a gitlab action. Gitlab will be the main focus for this project
- [ ] Build a github action. Github will be the secondary focus for this.
- [ ] Get the other shitcoin stuff working (Litecoin)
