#!/bin/sh -

set -e
set -o pipefail

if test -z ${1}
then
  echo "usage:   ${0##/*/} NODE"
  echo "example: ${0##/*/} node01.infra.amsdard.dev"
  exit 0
fi

knife node show ${1} -a ipaddress | awk 'NR > 1 {print $2}'
