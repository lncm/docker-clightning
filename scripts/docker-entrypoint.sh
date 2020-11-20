#!/usr/bin/env bash

# Original file (Upstream)
# https://raw.githubusercontent.com/ElementsProject/lightning/master/tools/docker-entrypoint.sh
# modified to include plugin path for building  my custom container

: "${EXPOSE_TCP:=false}"

networkdatadir="${LIGHTNINGD_DATA}/${LIGHTNINGD_NETWORK}"
HTTP_RPC_PLUGIN_PATH="/rust-plugin/c-lightning-http-plugin/target/release/c-lightning-http-plugin"

if [ "$EXPOSE_TCP" == "true" ]; then
    set -m
    lightningd --plugin="${HTTP_RPC_PLUGIN_PATH}" "$@" &

    echo "C-Lightning starting"
    while read -r i; do if [ "$i" = "lightning-rpc" ]; then break; fi; done \
    < <(inotifywait -e create,open --format '%f' --quiet "${networkdatadir}" --monitor)
    echo "C-Lightning started"
    echo "C-Lightning started, RPC available on port $LIGHTNINGD_RPC_PORT"

    socat "TCP4-listen:$LIGHTNINGD_RPC_PORT,fork,reuseaddr" "UNIX-CONNECT:${networkdatadir}/lightning-rpc" &
    fg %-
else
    exec lightningd --network="${LIGHTNINGD_NETWORK}" --plugin="${HTTP_RPC_PLUGIN_PATH}" "$@"
fi
