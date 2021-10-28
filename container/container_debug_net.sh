#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

PROG_NAME=${0##*/}
PROG_PATH=$(dirname ${0})

# source helpers and colours
source ${PROG_PATH}/container_helpers.sh
source ${PROG_PATH}/../colors.sh

# {{{ print_help()
print_help() {
  echo "usage:   ${0##/*/} CONTAINER [OPTIONS]"
  echo "example: ${0##/*/} grafana"
  echo
  echo ARGUMENTS:
  echo "  CONTAINER           : container name or id"
  echo
  echo OPTIONS:
  echo "  --help              : print this message"
  echo "  --image             : image to be used as a debug container, default: alpine:3"
  echo "  --command           : command to start debug container with, default: sh"
  echo "  --no-sudo           : do not use sudo when executing docker command, default: false"
  exit 0
}
# }}}
# {{{ defaults
IMAGE=alpine:3
COMMAND=/bin/sh
SUDO=sudo
# }}}
# {{{ option parsing
while test $# -gt 0
do
  case $1 in
  # {{{ help
  --help)
    print_help
    ;;
  -h)
    print_help
    ;;
  # }}}
  # {{{ options
  --image)
    IMAGE=${2}
    shift
    ;;
  --command)
    COMMAND=${2}
    shift
    ;;
  --no-sudo)
    SUDO=
    ;;
  # }}}
  # {{{ catch all
  -*)
    # catch unknown options but continue
    echo ${0##/*/}: $1: unknown option >&2
    ;;
  *)
    # save first non "-" argument as SEARCH
    SEARCH=${SEARCH:-${1}}
    ;;
  # }}}
  esac
  shift
done
# }}}

if test -z ${SEARCH}
then
  print_help
fi

find_container_id

echo "Found container ${CYAN}${CONTAINER_ID}${NORMAL}/${CYAN}${CONTAINER_NAME}${NORMAL} matching '${CYAN}${SEARCH}${NORMAL}'.."
echo "  ..executing ${CYAN}${IMAGE} ${COMMAND}${NORMAL} in its NETWORK and PID namespace"
echo
${SUDO} docker run -it --rm --net container:${CONTAINER_ID} --pid container:${CONTAINER_ID} ${IMAGE} ${COMMAND}
