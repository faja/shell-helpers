#!/bin/sh -

set -e
set -o pipefail

if test -z ${1} || \
   test -z ${2}
then
  echo "usage:   ${0##/*/} ENVIRONMENT ROLE"
  echo "example: ${0##/*/} prd traefik"
  exit 0
fi

knife search "chef_environment:${1} AND role:${2}" -a name | awk '/name:/ {print $2}'
