#!/bin/sh -

set -e
set -o pipefail

if test -z ${1}
then
  echo "usage:   ${0##/*/} CLUSTER"
  echo "example: ${0##/*/} arn:aws:eks:eu-central-1:990819986383:cluster/prd"
  exit 0
fi

CLUSTER=${1}
kubectl config unset users.${CLUSTER}
kubectl config delete-cluster ${CLUSTER}
kubectl config delete-context ${CLUSTER}
