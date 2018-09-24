#!/bin/bash

###
#
# Computes a witness for the given input parameters
# Exports corresponding proof to JSON for easy manipulation from web3js
#
# $1: path to compiled DSL app
# $*: Input parameters to app written in ZoKrates DSL
#
###

compiled_code=${1:-output/hello_world/out}
shift
witness=$*

ZOKRATES=/root/ZoKrates/target/release/zokrates
SUCCESSFUL_PROOF_DELIMITER="generate-proof successful: true"

# concatenate inputs params as a way to uniquely name witnesses/proofs
params_list=""
for p in "$@"; do
  params_list="${params_list}-${p}"
done

output_path=$(dirname "${compiled_code}")
witness_path="${output_path}/witness${params_list}"

"${ZOKRATES}" compute-witness \
  -a ${witness} \
  -i "${compiled_code}" \
  -o "${witness_path}"

bash -s << EOF > "${output_path}/proof${params_list}.json"
  echo '{'
  "${ZOKRATES}" generate-proof \
      -w "${witness_path}" \
      -i "${output_path}/variables.inf" \
      -p "${output_path}/proving.key" |\
    grep "${SUCCESSFUL_PROOF_DELIMITER}" -B 8 |\
    grep -v "${SUCCESSFUL_PROOF_DELIMITER}" |\
    sed -e 's,\(0x\w\+\),"\1",g' |\
    sed -e 's/\(.*\) = \(.*\)/"\1": [\2]/g' |\
    awk '{printf "%s%s",sep,\$0; sep=",\n"} END{print ""}'
  echo '}'
EOF

