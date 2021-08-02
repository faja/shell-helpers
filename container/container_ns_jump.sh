#!/bin/sh -

# TODO

set -e
set -o pipefail

if test -z ${1}
then
  echo "usage:   ${0##/*/} CONTAINER_ID"
  echo "example: ${0##/*/} 552520b94fe7"
  exit 0
fi

CONTAINER_ID=${1}
CONTAINER_NETNS=$(docker inspect ${CONTAINER_ID} --format '{{ .NetworkSettings.SandboxKey }}')

echo CONTAINER_ID: ${CONTAINER_ID}
echo CONTAINER_NETNS: ${CONTAINER_NETNS}
echo continue?
read ANSWER

mkdir -p /var/run/netns
rm -f /var/run/netns/${CONTAINER_ID}
ln -s ${CONTAINER_NETNS} /var/run/netns/${CONTAINER_ID}
ip netns exec ${CONTAINER_ID} bash
