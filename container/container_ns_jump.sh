#!/bin/bash -

set -e
set -o pipefail

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
  echo "  --no-sudo           : do not use sudo when executing docker command, default: false"
  exit 0
}
# }}}
# {{{ defaults
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
CONTAINER_NETNS=$(${SUDO} docker inspect ${CONTAINER_ID} --format '{{ .NetworkSettings.SandboxKey }}')

echo "Found container ${CYAN}${CONTAINER_ID}${NORMAL}/${CYAN}${CONTAINER_NAME}${NORMAL} matching '${CYAN}${SEARCH}${NORMAL}'.."
echo "  ..its network namespace is: ${CYAN}${CONTAINER_NETNS}${NORMAL}"
echo
echo "  do the NET jump?"
read ANSWER
echo "  ${RED}NOTE:${NORMAL} once you done, please remember to remove netns file: /var/run/netns/${CONTAINER_ID})"
echo

${SUDO} mkdir -p /var/run/netns
${SUDO} rm -f /var/run/netns/${CONTAINER_ID}
${SUDO} ln -s ${CONTAINER_NETNS} /var/run/netns/${CONTAINER_ID}
${SUDO} ip netns exec ${CONTAINER_ID} bash
