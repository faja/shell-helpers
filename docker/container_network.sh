#!/bin/sh -

set -e
set -o pipefail

if test -z ${1}
then
  echo "usage:   ${0##/*/} CONTAINER_ID"
  echo "example: ${0##/*/} 552520b94fe7"
  exit 0
fi

CONTAINER_ID=${1}
docker container inspect ${CONTAINER_ID} -f '{{ .Name }} - network mode: {{ .HostConfig.NetworkMode }}'
