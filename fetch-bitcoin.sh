BITCOIN_VERSION="0.20.1"
BITCOIN_TARBALL="bitcoin-${BITCOIN_VERSION}-${aarch64:-`uname -m`}-linux-gnu.tar.gz"
BITCOIN_URL="https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/$BITCOIN_TARBALL"

BITCOIN_ASC_URL="https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/SHA256SUMS.asc"

echo "Extract and verify"
wget -qO $BITCOIN_TARBALL $BITCOIN_URL
wget -qO bitcoin.asc "$BITCOIN_ASC_URL"
grep $BITCOIN_TARBALL bitcoin.asc | tee SHA256SUMS.asc
sha256sum -c SHA256SUMS.asc
BD=bitcoin-$BITCOIN_VERSION/bin
tar -xzvf $BITCOIN_TARBALL $BD/bitcoin-cli --strip-components=1
ls -la
ls -la bin/
rm $BITCOIN_TARBALL
