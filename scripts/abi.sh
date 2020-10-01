#!/usr/bin/env bash

# Contracts to extract the ABI for:
contracts=(
  UniswapV2Router02
)

usage() {
   cat << EOT
Usage: $0 [option] command
Options:
   --archive  create a tar.gz version of the abis
   --help     print this help
EOT
}

while [ $# -gt 0 ]
do
  case $1 in
  --archive) archive=true;;
  -h|--help) usage; exit 1;;
  (--) shift; break;;
  (-*) usage; exit 1;;
  (*) break;;
  esac
  shift
done

set_defaults() {    
  if [ -z "$archive" ]; then
    archive=false
  fi
}

extract_abi() {
  set_defaults

  rm -rf build/abi
  mkdir -p build/abi

  for contract in "${contracts[@]}"; do
    cat build/contracts/${contract}.json | jq -c '.abi' > build/abi/${contract}.json
  done

  cd build/abi

  if [ "$archive" = true ]; then
    tar -czvf abi.tar.gz *.json
  fi  
}

extract_abi
