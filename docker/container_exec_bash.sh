#!/bin/sh -

set -e

if test -z ${1}
then
  echo "usage:   ${0##/*/} CONTAINER_NAME"
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

docker exec -it ${CONTAINER_ID} bash
