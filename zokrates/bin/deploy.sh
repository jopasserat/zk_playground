#!/bin/bash

###
#
# Installs newly generated contract in truffle project
# Then runs migration to deploy (to local ganache chain for the moment)
#
# $1: path to generated Verifier contract
#
###

WORKDIR=zokrates+web3js
verifier_contract=${1:-output/hello_world/verifier.sol}

mkdir -p "${WORKDIR}"
cp "${verifier_contract}" "${WORKDIR}/contracts/"
cd "${WORKDIR}" || exit 1
truffle compile
truffle migrate

