#!/bin/bash -

SCRIPT_VERSION=1.0.0

MODULE_PATH=~/GitRepos/AS/INFRA/infra-terraform-aws-modules
cd ${MODULE_PATH}
echo pulling latest changes from git..
git pull origin master

echo
echo

printf "%-30s\t%10s\n" "MODULE NAME" "VERSION"

for dir in $(ls -l)
do
  if ! test -d "$dir"
  then
    continue
  fi

  VERSION=$(head -2 $dir/README.md | tail -1)
  # lets skip copy-pase and work in progress modules
  if echo "${VERSION}" | grep -q -e 'Copy-Paste' -e 'WORK IN PROGRESS'
  then
    continue
  fi

  printf "%-30s\t%10s\n" "${dir}" "${VERSION}"
done
