#!/bin/sh -

set -e
set -o pipefail

kubectl get pods -o custom-columns="NAME:.metadata.name,CONTAINERS:.spec.containers[*].image,INIT_CONTAINERS:.spec.initContainers[*].image"
