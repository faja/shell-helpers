#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

if test -z ${1}
then
  echo "usage:   ${0##/*/} NODE"
  echo "example: ${0##/*/} node01.infra.amsdard.dev"
  exit 0
fi

knife node show ${1} -F json | jq -r '.run_list[]'
