#!/bin/bash -

set -e
set -o pipefail

SCRIPT_VERSION=1.0.0

PROG_NAME=${0##*/}
PROG_PATH=$(dirname ${0})

# {{{ print_help()
print_help() {
  echo "usage:   ${PROG_NAME} ARG1 ARG2 [OPTIONS]"
  echo "example: ${PROG_NAME} arg1 arg2 --api-version 0.1.0"
  echo
  echo OPTIONS:
  echo "  --help              : print this message"
  echo "  --verbose           : be more verbose / print stack information"
  echo "  --yes               : do not ask for confirmation"
  echo "  --api-image         : api service image"
  echo "  --api-version       : api service version(tag)"
  echo "  --client-image      : client service image"
  echo "  --client-version    : client service version(tag)"
  echo "  --proxy-image       : proxy service image"
  echo "  --proxy-version     : proxy service version(tag)"
  exit 0
}
# }}}
# {{{ ask_continue()
ask_continue() {
  if test -z ${YES}
  then
    echo continue?
    read ANSWER
  fi
}
# }}}
# {{{ verbose()
verbose() {
  if test ${VERBOSE}
  then
    echo STACK=${STACK}
    echo API_IMAGE=${API_IMAGE}
    echo API_VERSION=${API_VERSION}
    echo CLIENT_IMAGE=${CLIENT_IMAGE}
    echo CLIENT_VERSION=${CLIENT_VERSION}
    echo PROXY_IMAGE=${PROXY_IMAGE}
    echo PROXY_VERSION=${PROXY_VERSION}
  fi
}
# }}}
# {{{ defaults
SOME_DEFAULT=xxx
SOME_DEFAULT2=
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
  --yes)
    YES=true
    ;;
  --verbose)
    VERBOSE=true
    ;;
  # }}}
  # {{{ options
  --api-image)
    API_IMAGE=${2}
    shift
    ;;
  --api-version)
    API_VERSION=${2}
    shift
    ;;
  --client-image)
    CLIENT_IMAGE=${2}
    shift
    ;;
  --client-version)
    CLIENT_VERSION=${2}
    shift
    ;;
  --proxy-image)
    PROXY_IMAGE=${2}
    shift
    ;;
  --proxy-version)
    PROXY_VERSION=${2}
    shift
    ;;
  # }}}
  # {{{ catch all
  -*)
    # catch unknown options but continue
    echo ${0##/*/}: $1: unknown option >&2
    ;;
  *)
    # save first non "-" argument as ARG1
    ARG1=${ARG1:-${1}}
    ARG2=${ARG2:-${2}}
    ;;
  # }}}
  esac
  shift
done
# }}}

if test -z "${ARG1}" || \
   test -z "${ARG2}"
then
  print_help
fi

verbose
ask_continue

echo
echo processing
echo ARG1: ${ARG1}
echo ARG2: ${ARG2}
