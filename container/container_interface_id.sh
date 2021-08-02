#!/bin/sh -

# TODO

set -e
set -o pipefail

if test -z ${1}
then
  echo "usage:   ${0##/*/} CONTAINER_NAME|CONTAINER_ID"
  echo "example: ${0##/*/} redis"
  exit 0
fi

CONTAINER_NAME=${1}
CONTAINER_ID=$(docker ps | grep ${CONTAINER_NAME} | awk '{print $1}')
CONTAINER_COUNT=$(echo "${CONTAINER_ID}" | wc -l)

if test -z "${CONTAINER_ID}"
then
  echo did not find any container maching \'${CONTAINER_NAME}\'
  exit 1
fi

if test ${CONTAINER_COUNT} -gt 1
then
  echo found more than 1 container maching \'${CONTAINER_NAME}\'
  exit 1
fi

IF_ID=$(docker exec ${CONTAINER_ID} cat /sys/class/net/eth0/iflink)
ip a | awk -vpat=${IF_ID}: '$1 == pat {print $2}' | awk -F@ '{print $1}'
