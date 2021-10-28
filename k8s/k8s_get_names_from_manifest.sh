#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

if test -z ${1} || \
   test -z ${2}
then
  echo "usage:   ${0##/*/} RESOURCE_KIND FILE"
  echo "example: ${0##/*/} Deployment install.yaml"
  exit 0
fi

yq -r --arg kind ${1} '. | select(.kind == $kind) | .metadata.name' ${2}
