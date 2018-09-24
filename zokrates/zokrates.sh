#!/bin/bash

command_line=${*:-/bin/bash}

docker run \
  --rm -it \
  -w /my_example \
  --volume "$(pwd)":/my_example \
  zokrates/zokrates \
  ${command_line}

