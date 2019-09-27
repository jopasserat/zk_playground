#!/bin/bash

###
#
# Installs newly generated contract in truffle project
# Then runs migration to deploy (to local ganache chain for the moment)
#
# $1: path to generated Verifier contract
# $2: root path where to copy the web3 files to (contracts, truffle config, ...)
# $3: flag to also deploy the webapp example (default is "withweb")
#
###

shopt -s extglob

verifier_contract=${1:-output/hello_world/verifier.sol}
WORKDIR=${2:-zokrates+web3js}
DEPLOY_WEBAPP=${3:-"withweb"}

SOURCE_DIR="$(readlink -f $(dirname $0))/../zokrates+web3js"

mkdir -p "${WORKDIR}"
if [ ${DEPLOY_WEBAPP} == "withweb" ]; then
  cp -rT "${SOURCE_DIR}" "${WORKDIR}"
else
  cp -r "${SOURCE_DIR}"/!(src|bs-config.json|node_modules|build) "${WORKDIR}"
  cp "${SOURCE_DIR}/.env" "${WORKDIR}/.env"
fi

# overwrite template verifier.sol with the one generated for this circuit
cp "${verifier_contract}" "${WORKDIR}/contracts/"

cd "${WORKDIR}" || exit 1

npm install
truffle migrate

