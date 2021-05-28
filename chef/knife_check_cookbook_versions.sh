#!/bin/bash -

BERKSFILE=./Berksfile
COOKBOOK_PATH=~/GitRepos/AS/INFRA/infra-chef-cookbooks/master

printf "%-20s\t%15s\t%15s\n" COOKBOOK VERSION_CURRENT VERSION_AVAILABLE
for COOKBOOK in $(awk -F"'" '/^cookbook/ {print $2}' ${BERKSFILE})
do
  VERSION_CURRENT=$(awk -F"'" -vp=${COOKBOOK} '/^cookbook/ && $2 == p' ${BERKSFILE} | awk -F"'" '{print $4}')
  VERSION_AVAILABLE=$(awk -F"'" '/^version/ {print $2}' ${COOKBOOK_PATH}/${COOKBOOK}/metadata.rb)
  printf "%-20s\t%15s\t%15s\n" ${COOKBOOK} "${VERSION_CURRENT}" ${VERSION_AVAILABLE}
done
