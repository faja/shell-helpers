#!/bin/bash -

set -e
set -o pipefail

if test -z ${1}
then
  echo "usage:   ${0##/*/} IMAGE [SHELL]"
  echo "example: ${0##/*/} golang:alpine sh"
  echo
  echo ARGS:
  echo "  IMAGE      : docker image to run"
  echo "  SHELL      : shell to execute (default: bash)"
  exit 0
fi

CONTAINER_NAME=${1}
SHELL=${2:-bash}

docker run -it --rm ${CONTAINER_NAME} ${SHELL}
