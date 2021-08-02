#!/bin/bash -

# {{{ find_container_id
find_container_id() {
  CONTAINER_ID=$(${SUDO} docker ps | grep ${SEARCH} | awk '{print $1}')
  CONTAINER_COUNT=$(echo "${CONTAINER_ID}" | wc -l)

  if test -z "${CONTAINER_ID}"
  then
    echo did not find any container maching \'${CONTAINER_NAME}\'
    exit 1
  fi

  if test ${CONTAINER_COUNT} -gt 1
  then
    echo found more than 1 container maching \'${SEARCH}\'
    exit 1
  fi

  CONTAINER_NAME=$(${SUDO} docker inspect ${CONTAINER_ID} -f '{{ .Name }}' | sed 's|/||')
}
# }}}
# {{{ find_container_pid
find_container_pid() {
  find_container_id
  CONTAINER_PID=$(${SUDO} docker inspect ${CONTAINER_ID} -f '{{ .State.Pid }}')
}
# }}}
