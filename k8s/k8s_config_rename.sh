#!/bin/sh -

set -e
set -o pipefail

if test -z ${1} || \
   test -z ${2}
then
  echo "usage:   ${0##/*/} OLD_NAME NEW_NAME"
  echo "example: ${0##/*/} arn:aws:eks:eu-central-1:990819986383:cluster/prd prd"
  exit 0
fi

OLD=${1}
NEW=${2}

# {{{ verify
if ! kubectl config view -o jsonpath="{ .clusters[?( @.name == \"${OLD}\" )].name }" | grep -q ${OLD}
then
  echo cluster ${OLD} does not exist in your \$KUBEKONFIG
  exit 1
fi
if ! kubectl config view -o jsonpath="{ .contexts[?( @.name == \"${OLD}\" )].name }" | grep -q ${OLD}
then
  echo context ${OLD} does not exist in your \$KUBEKONFIG
  exit 1
fi
if ! kubectl config view -o jsonpath="{ .users[?( @.name == \"${OLD}\" )].name }" | grep -q ${OLD}
then
  echo user ${OLD} does not exist in your \$KUBEKONFIG
  exit 1
fi
# }}}

cp -f ~/.kube/config{,.back}
sed -i \
    -e "\^name: ${OLD}\$^s//name: ${NEW}/" \
    -e "\^user: ${OLD}\$^s//user: ${NEW}/" \
    -e "\^cluster: ${OLD}\$^s//cluster: ${NEW}/" \
    ~/.kube/config
