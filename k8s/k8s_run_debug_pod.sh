#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

# {{{ print_help()
print_help() {
  echo "usage:   ${0##/*/} [IMAGE] [COMMAND]"
  echo "example: ${0##/*/} centos:7 bash"
  echo
  echo DEFAULTS:
  echo "  IMAGE   : busybox:latest"
  echo "  COMMAND : /bin/sh"
  echo
  echo OPTIONS:
  echo "  --help  : print this message"
  exit 0
}
# }}}
# {{{ option parsing
while test $# -gt 0
do
  case $1 in
  # {{{ help, yes, verbose
  --help)
    print_help
    ;;
  -h)
    print_help
    ;;
  # }}}
  # {{{ catch all
  -*)
    # catch unknown options but continue
    echo ${0##/*/}: $1: unknown option >&2
    ;;
  *)
    # save first non "-" argument as IMAGE
    # save second non "-" argument as COMMAND
    if test -z ${IMAGE}
    then
      IMAGE=${1}
    else
      COMMAND=${COMMAND:-${1}}
    fi
    ;;
  # }}}
  esac
  shift
done
# }}}

IMAGE=${IMAGE:-busybox:latest}
COMMAND=${COMMAND:-/bin/sh}

#kubectl run debug-pod --image=${IMAGE} --rm -it --restart=Never --command -- ${COMMAND}
echo kubectl run debug-pod --image=${IMAGE} --rm -it --restart=Never --command -- ${COMMAND}
