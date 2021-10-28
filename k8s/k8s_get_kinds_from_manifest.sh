#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

if test -z ${1}
then
  echo "usage:   ${0##/*/} FILE"
  echo "example: ${0##/*/} install.yaml"
  exit 0
fi

yq -r '.kind' ${1} | sort | uniq -c
