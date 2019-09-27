# Toying with ZoKrates

## Description

- A single smart contract is generated from Verification key => Verifier SC
- For each new set of inputs, *Prover* runs the application on his untrusted environment.
- He obtains the result and can compute a **witness** for this result.
- From the **witness**, *Prover* generates a proof using the Proving key.
- He then publishes this new proof along with the corresponding result.
- *Verifier* (or anyone else) can pick the proof and the contract returns `true`/`false` for a set of public inputs and outputs

- Each different pair of inputs/outputs requires a **different proof** but can be verified using the same contract.

## How to use

### Quick intro

- Use the `zokrates.sh` script as an entry point to interact with ZoKrates.
- By default it will start a shell in the ZoKrates docker image.
- `zokrates.sh` accepts any command as a parameter:
  - ex: `zokrates.sh ls`

- The example application is taken from [Pepper's hello world](https://github.com/pepper-project/pequin/blob/master/pepper/apps/hello_world.c) and multiplies the 2x2 matrix *[0x12 0x5; 0x3 0x2]* with an 2x1 input vector (*[2 2] in our example below*).

### Prerequisites

- Install:
  - `docker`
  - `truffle`
  - `ganache || hyperledger besu` (only two clients tested so far)

### Classic deployment

```bash
./zokrates.sh bin/build_verifier.sh apps/hello_world.code output
./zokrates.sh bin/generate_proof.sh output/hello_world/out 2 2
# note that this last stage runs on the host, not in docker
./bin/deploy.sh output/hello_world/verifier.sol
cd zokrates+web3js
# here you can update the content of the .env file to accommodate your own network
# and call `truffle migrate` again
npm run dev
```

- This will open a new tab in your browser with the shiny test web app :sunglasses:
- Load the proof from the file selector, then fill in the fields:
  - `B1`, `B2` are the components of the input vector (*`B1 = 2` and `B2 = 2` in our example*)
  - `Out1` and `Out2` are the components of the output vector (*`Out1 = 46` and `Out2 = 10` in our example*)
- Open the javascript dev console (F12 or CTRL-C depending on your browser's key mappings).
- Press the `Verify` button and you should see a successful output in the console.
