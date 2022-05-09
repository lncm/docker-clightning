ARG REPO=https://github.com/ElementsProject/lightning.git
ARG VERSION=v0.10.2
ARG USER=lightning
ARG DATA=/data

FROM debian:buster-slim as downloader

ARG REPO
ARG VERSION

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr wget

WORKDIR /opt

# Fetch and verify bitcoin (As per arch)
COPY ./fetch-scripts/fetch-bitcoin.sh .
RUN chmod 755 fetch-bitcoin.sh
RUN ./fetch-bitcoin.sh

#ENV LITECOIN_VERSION 0.16.3
#ENV LITECOIN_PGP_KEY FE3348877809386C
#ENV LITECOIN_URL https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz
#ENV LITECOIN_ASC_URL https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc
#ENV LITECOIN_SHA256 686d99d1746528648c2c54a1363d046436fd172beadaceea80bdc93043805994

# install litecoin binaries
#RUN mkdir /opt/litecoin && cd /opt/litecoin \
#    && wget -qO litecoin.tar.gz "$LITECOIN_URL" \
#    && echo "$LITECOIN_SHA256  litecoin.tar.gz" | sha256sum -c - \
#    && BD=litecoin-$LITECOIN_VERSION/bin \
#    && tar -xzvf litecoin.tar.gz $BD/litecoin-cli --strip-components=1 --exclude=*-qt \
#    && rm litecoin.tar.gz

FROM debian:buster-slim as builder

ARG VERSION
ARG REPO

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates autoconf \
    automake build-essential git libtool python python3 python3-mako \
    wget gnupg dirmngr git gettext libgmp-dev libsqlite3-dev net-tools \
    zlib1g-dev unzip tclsh git libsodium-dev libpq-dev valgrind python3-pip \
    valgrind libpq-dev shellcheck cppcheck \
    libsecp256k1-dev jq \
    python3-setuptools \
    python3-dev
RUN pip3 install mrkd wheel mistune==0.8.4

ARG DEVELOPER=0

WORKDIR /opt
RUN git clone --recurse-submodules $REPO && \
    cd lightning && \
    ls -la && \
    mkdir -p /tmp/lightning_install && \
    ls -la /tmp && \
    git checkout $VERSION && \
    echo "Configuring" && \
    ./configure --prefix=/tmp/lightning_install \
        --enable-static && \
    echo "Building" && \
    make -j3 DEVELOPER=${DEVELOPER} && \
    echo "installing" && \
    make install && \
    ls -la  /tmp/lightning_install

FROM debian:buster-slim as final
ARG USER
ARG DATA

LABEL maintainer="nolim1t (hello@nolim1t.co)"

RUN apt-get update && apt-get install -y --no-install-recommends git socat inotify-tools python3 python3-pip cargo \
    libpq-dev libsodium-dev nodejs npm \
    && rm -rf /var/lib/apt/lists/*


COPY --from=builder /lib /lib
COPY --from=builder /tmp/lightning_install/ /usr/local/
COPY --from=downloader /opt/bin /usr/bin
COPY ./scripts/docker-entrypoint.sh entrypoint.sh

RUN mkdir /rust-plugin && \
    chown 1000.1000 /rust-plugin

# Build and install http rust plugin to the following dir
# /rust-plugin/c-lightning-http-plugin/target/release/c-lightning-http-plugin
#RUN echo "Installing start9labs rust http plugin" && \
#    cd /rust-plugin && \
#    echo "Checkout plugin" && \
#    git clone https://github.com/Start9Labs/c-lightning-http-plugin.git && \
#    echo "Installing plugin" && \
#    cd c-lightning-http-plugin && \
#    cargo build --release && \
#    echo "verify plugin" && \
#    ls -la target/release/c-lightning-http-plugin && \
#    pwd



RUN adduser --disabled-password \
    --home "$DATA" \
    --gecos "" \
    "$USER"
USER $USER 

ENV LIGHTNINGD_DATA=$DATA/.lightning
ENV LIGHTNINGD_RPC_PORT=9835
ENV LIGHTNINGD_PORT=9735
ENV LIGHTNINGD_NETWORK=bitcoin

# Setup home directory
#RUN mkdir $LIGHTNINGD_DATA && \
#    touch $LIGHTNINGD_DATA/config
#VOLUME [ "/data/.lightning" ]

EXPOSE 9735 9736 9835 9836 19735 19736 19835 19836

ENTRYPOINT  [ "./entrypoint.sh" ]
