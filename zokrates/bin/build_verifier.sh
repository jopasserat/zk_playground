#!/bin/bash

###
#
# Run the setup and generate a verifier contract
# Will generate output files in current directory
#
# $1: path to app written in ZoKrates DSL
# $2: path to output folder
#
###

input_app=${1:-apps/hello_world.code}
output_folder=${2:-output}

ZOKRATES=/home/zokrates/zokrates
output_folder_app="${output_folder}/$(basename ${input_app} .code)"
output_code="${output_folder_app}/out"

mkdir -p "${output_folder_app}"

"${ZOKRATES}" compile -i "${input_app}" -o "${output_code}"
"${ZOKRATES}" setup -i "${output_code}" \
  -p "${output_folder_app}/proving.key" \
  -v "${output_folder_app}/verification.key"
"${ZOKRATES}" export-verifier \
  -i "${output_folder_app}/verification.key" \
  -o "${output_folder_app}/verifier.sol"

