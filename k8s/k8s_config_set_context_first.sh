#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

if ! test -z ${1}
then
  echo "usage:   ${0##/*/}"
  echo "example: ${0##/*/}"
  exit 0
fi

CONTEXT=$(kubectl config view -o jsonpath='{ .contexts[0].name }')
kubectl config use-context ${CONTEXT}
