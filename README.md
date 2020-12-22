# C-Lightning in a Docker container

[![pipeline status](https://gitlab.com/nolim1t/docker-clightning/badges/master/pipeline.svg)](https://gitlab.com/lncm/docker-clightning/-/commits/master)
[![Build on tag](https://github.com/lncm/docker-clightning/workflows/Docker%20build%20on%20tag/badge.svg)](https://github.com/lncm/docker-clightning/actions?query=workflow%3A%22Docker+build+on+tag%22)
[![Build on push](https://github.com/lncm/docker-clightning/workflows/Docker%20build%20on%20push/badge.svg)](https://github.com/lncm/docker-clightning/actions?query=workflow%3A%22Docker+build+on+push%22)
![Version](https://img.shields.io/github/v/release/lncm/docker-clightning?sort=semver) 
[![Docker Pulls Count](https://img.shields.io/docker/pulls/lncm/clightning.svg?style=flat)](https://hub.docker.com/r/lncm/clightning)

## What

[C-Lightning](https://github.com/ElementsProject/lightning) by [Elements Project](https://github.com/ElementsProject/) in a [docker container](https://gitlab.com/nolim1t/docker-clightning) for easy orchestration on embedded devices (like the Raspberry Pi), and auto-building.

Also to enable [FullyNoded](https://github.com/Fonta1n3/FullyNoded/) (currently, and maybe other stuff in future) to work properly, I've also bundled in the [http rpc plugin](https://github.com/Start9Labs/c-lightning-http-plugin) by [Start9Labs](https://github.com/Start9Labs).

## Why?

To do cross-platform builds the [LNCM](https://github.com/lncm/) way, like some of my other containers

## Mirrors

Where this code is maintained and mirrored (master branch).

* [Gitlab](https://gitlab.com/nolim1t/docker-clightning)
* [Github](https://github.com/lncm/docker-clightning)

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
    --build-arg VERSION=v0.9.2 \
    -t nolim1t/clightning:v0.9.2 .
```
The other configurables you can use are:

- `REPO` defines the master repo for lightning (eventually would like to make this fetch from TOR so the whole thing is anonymous)
- `USER` defines the user name (Its cosmetic at this stage)
- `DATA` defines the data folder for lightning user within the container

## Running

For convenience, we have a sample [docker-compose](https://gitlab.com/nolim1t/docker-clightning/-/raw/master/docker-compose.yml-dist) file and a [sample config file](https://gitlab.com/nolim1t/docker-clightning/-/raw/master/doc/config.dist)
you may use (this is based off the [documentation](https://github.com/ElementsProject/lightning/blob/master/doc/lightningd-config.5.md) on the upstream).

Or running straight from docker after building it:

```bash
# Assuming you have built it (This uses the similar parameters as the above docker-compose)
docker run -it --rm \
    --name clightning \
    -e LIGHTNINGD_NETWORK=bitcoin \
    -e LIGHTNINGD_RPC_PORT=10420 \
    -v $HOME/.lightning:/data/.lightning \
    -v $HOME/.bitcoin:/data/.bitcoin \
    lncm/clightning:v0.9.2

# or if using gitlab
docker run -it --rm \
    --name clightning \
    -e LIGHTNINGD_NETWORK=bitcoin \
    -e LIGHTNINGD_RPC_PORT=10420 \
    -v $HOME/.lightning:/data/.lightning \
    -v $HOME/.bitcoin:/data/.bitcoin \
    registry.gitlab.com/nolim1t/docker-clightning:v0.9.2-e93f2979
```

## Using the RPC Interface

You will need to add the following to your config file:

* `http-user`
* `http-pass`
* `http-bind` (hostname and port)

Then you can pass whatever RPC commands to your C Lightning node!

Example:

```bash
curl "http://lightning:lightningpass@localhost:1312" \
    -d '{"id": "rpctest", "method": "getinfo", "params": []}'
```

Please keep in mind the RPC is probably not fully hardened for public internet access. You may want to put this behind a https proxy or TOR node!

## Todo

Most stuff is in the [issues list](https://gitlab.com/nolim1t/docker-clightning/-/issues) however the below is kept for legacy purposes

- [x] Document how to build this project for more advanced users
- [x] Document how to use this container (config files, etc)
- [x] Build a docker compose file as an example
- [x] Build a gitlab action. Gitlab will be the main focus for this project
- [x] Build a github action. Github will be the secondary focus for this.
- [ ] Extremely low priority. Get the other shitcoin stuff working (Litecoin)
