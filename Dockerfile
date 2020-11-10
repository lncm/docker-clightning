ARG REPO=https://github.com/ElementsProject/lightning.git
ARG VERSION=v0.9.1
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

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates autoconf automake build-essential git libtool python3 python3-mako wget gnupg dirmngr git gettext libgmp-dev libsqlite3-dev net-tools zlib1g-dev unzip tclsh git

WORKDIR /opt
RUN git clone $REPO
WORKDIR /opt/lightning
RUN ls -la
RUN mkdir -p /tmp/lightning_install

RUN git checkout $VERSION
#RUN git clone --recursive /tmp/lightning . && \
#    git checkout $(git --work-tree=/tmp/lightning --git-dir=/tmp/lightning/.git rev-parse HEAD)

ARG DEVELOPER=0
RUN ./configure --prefix=/tmp/lightning_install --enable-static && make -j3 DEVELOPER=${DEVELOPER} && make install

FROM debian:buster-slim as final
ARG USER
ARG DATA

LABEL maintainer="nolim1t (hello@nolim1t.co)"

RUN apt-get update && apt-get install -y --no-install-recommends socat inotify-tools python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*


COPY --from=builder /lib /lib
COPY --from=builder /tmp/lightning_install/ /usr/local/
COPY --from=downloader /opt/bin /usr/bin
COPY --from=builder /opt/lightning/tools/docker-entrypoint.sh entrypoint.sh

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
