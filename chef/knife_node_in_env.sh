#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

if test -z ${1}
then
  echo "usage:   ${0##/*/} ENVIRONMENT"
  echo "example: ${0##/*/} prd"
  exit 0
fi

knife search chef_environment:${1} -a name | awk '/name:/ {print $2}'
