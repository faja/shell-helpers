#!/bin/sh -

# TODO

set -e
set -o pipefail

# {{{ print_help()
print_help() {
  echo "usage:   ${0##/*/} CONTAINER [OPTIONS]"
  echo "example: ${0##/*/} centos --short"
  echo
  echo ARGUMENTS:
  echo "  CONTAINER           : container name or id"
  echo
  echo OPTIONS:
  echo "  --help              : print this message"
  echo "  --short             : print only ip address"
  echo "  --must-be-one       : exit 1 if found more than 1 container"
  exit 0
}
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
  --short)
    SHORT=true
    ;;
  --must-be-one)
    MUST_BE_ONE=true
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

ID=$(docker ps --format "{{.ID}}\t{{.Names}}" | grep ${SEARCH} | awk '{print $1}')
ID_COUNT=$(echo "${ID}" | wc -l)

if test ${MUST_BE_ONE}
then
  if test ${ID_COUNT} -gt 1
  then
    echo please be more specific, more than one container found maching \'${SEARCH}\':
    docker ps --format "{{.ID}}\t{{.Names}}" | grep ${SEARCH}
    exit 1
  fi
fi

if test ${SHORT}
then
  docker container inspect ${ID} -f '{{.Name}}: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | awk '{print $2}'
else
  docker container inspect ${ID} -f '{{.Name}}: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
fi
