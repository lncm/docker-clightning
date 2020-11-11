# C-Lightning in a Docker container

[![pipeline status](https://gitlab.com/nolim1t/docker-clightning/badges/master/pipeline.svg)](https://gitlab.com/lncm/docker-clightning/-/commits/master)
[![Build on tag](https://github.com/lncm/docker-clightning/workflows/Docker%20build%20on%20tag/badge.svg)](https://github.com/lncm/docker-clightning/actions?query=workflow%3A%22Docker+build+on+tag%22)
[![Build on push](https://github.com/lncm/docker-clightning/workflows/Docker%20build%20on%20push/badge.svg)](https://github.com/lncm/docker-clightning/actions?query=workflow%3A%22Docker+build+on+push%22)
![Version](https://img.shields.io/github/v/release/lncm/docker-clightning?sort=semver) 
[![Docker Pulls Count](https://img.shields.io/docker/pulls/lncm/clightning.svg?style=flat)](https://hub.docker.com/r/lncm/clightning)

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
- [x] Document how to use this container (config files, etc)
- [x] Build a docker compose file as an example
- [x] Build a gitlab action. Gitlab will be the main focus for this project
- [x] Build a github action. Github will be the secondary focus for this.
- [ ] Get the other shitcoin stuff working (Litecoin)
