#!/bin/bash

###
#
# Installs newly generated contract in truffle project
# Then runs migration to deploy (to local ganache chain for the moment)
#
# $1: path to generated Verifier contract
# $2: root path where to copy the web3 files to (contracts, truffle config, ...)
#
###

verifier_contract=${1:-output/hello_world/verifier.sol}
WORKDIR=${2:-zokrates+web3js}
SOURCE_DIR=$(readlink -f $(dirname $0))

mkdir -p "${WORKDIR}/contracts"
cp "${verifier_contract}" "${WORKDIR}/contracts/"
cd "${WORKDIR}" || exit 1
truffle compile
truffle migrate

