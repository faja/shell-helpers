#!/bin/sh -

set -e
set -o pipefail

if test -z ${1}
then
  echo "usage:   ${0##/*/} OPTION"
  echo "example: ${0##/*/} option"
  exit 0
fi

echo ${1}
