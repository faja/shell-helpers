#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

kubectl get pods -o custom-columns="NAME:.metadata.name,CONTAINERS:.spec.containers[*].image,INIT_CONTAINERS:.spec.initContainers[*].image"
