#!/bin/sh -

set -e
set -o pipefail

ALL_NAMESPACES=""
if test "${1}" == "-A"
then
ALL_NAMESPACES="--all-namespaces=true"
fi

kubectl ${ALL_NAMESPACES} get pods -o custom-columns="NAME:.metadata.name,HOST_IP:.status.hostIP"
