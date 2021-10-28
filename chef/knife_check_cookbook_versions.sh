#!/bin/bash -

SCRIPT_VERSION=1.0.0

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
  # {{{ options
  --env)
    ENV=${2}
    shift
    ;;
  # }}}
  # {{{ catch all
  -*)
    # catch unknown options but continue
    echo ${0##/*/}: $1: unknown option >&2
    ;;
  *)
    ;;
  # }}}
  esac
  shift
done
# }}}
# {{{ colors
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
#NORMAL=
#RED=
# }}}

BERKSFILE=./Berksfile
LOCAL_COOKBOOK_PATH=./cookbooks
REMOTE_COOKBOOK_PATH=~/GitRepos/AS/INFRA/infra-chef-cookbooks/master
CHEF_COOKBOOK_VERSIONS=$(knife cookbook list)

if test "${ENV}"
then
  printf "%-20s\t%17s\t%17s\t%17s\t%17s\n" COOKBOOK VERSION_IN_BERKS VERSION_IN_CHEF VERSION_IN_ENV_FILE VERSION_AVAILABLE
else
  printf "%-20s\t%17s\t%17s\t%17s\n" COOKBOOK VERSION_IN_BERKS VERSION_IN_CHEF VERSION_AVAILABLE
fi

for COOKBOOK in $(awk -F"'" '/^cookbook/ {print $2}' ${BERKSFILE})
do
  VERSION_IN_BERKSFILE=$(awk -F"'" -vp=${COOKBOOK} '/^cookbook/ && $2 == p' ${BERKSFILE} | awk -F"'" '{print $4}')
  VERSION_IN_CHEF_SERVER=$(echo "${CHEF_COOKBOOK_VERSIONS}" | awk -vp=${COOKBOOK} '$1 == p {print $2}')
  if test -d ${LOCAL_COOKBOOK_PATH}/${COOKBOOK}
  then
    COOKBOOK_PATH=${LOCAL_COOKBOOK_PATH}
  else
    COOKBOOK_PATH=${REMOTE_COOKBOOK_PATH}
  fi
  if test -f ${COOKBOOK_PATH}/${COOKBOOK}/metadata.rb
  then
    VERSION_AVAILABLE=$(awk -F"'" '/^version/ {print $2}' ${COOKBOOK_PATH}/${COOKBOOK}/metadata.rb)
  else
    VERSION_AVAILABLE=check_manually
  fi

  # cookbook version in env file (if specified)
  if test "${ENV}"
  then
    VERSION_IN_ENV_FILE=$(jq -r --arg cookbook "${COOKBOOK}" '.cookbook_versions[$cookbook]' "${ENV}")
  fi

  if test ${VERSION_IN_CHEF_SERVER} != ${VERSION_AVAILABLE}
  then
    printf "${RED}"
  fi
  if test "${ENV}"
  then
    if ! test "${VERSION_IN_ENV_FILE}" = "${VERSION_AVAILABLE}"
    then
      printf "${RED}"
    fi
    printf "%-20s\t%17s\t%17s\t%17s\t%17s\n" ${COOKBOOK} "${VERSION_IN_BERKSFILE}" "${VERSION_IN_CHEF_SERVER}" "${VERSION_IN_ENV_FILE}" "${VERSION_AVAILABLE}"
  else
    printf "%-20s\t%17s\t%17s\t%17s\n" ${COOKBOOK} "${VERSION_IN_BERKSFILE}" "${VERSION_IN_CHEF_SERVER}" "${VERSION_AVAILABLE}"
  fi
  printf "${NORMAL}"
done
