#!/bin/bash -

##
# updates kubeconfig with admin user and cluster details
# from freshly lanuched kubernetes cluster via chef
##

SCRIPT_VERSION=1.0.0

HOSTNAME=${1}
CLUSTERNAME=${2}
PROG_NAME=${0##*/}

if test -z ${1} || test -z ${2}
then
  echo "usage:   ${PROG_NAME} IP/FQDN CLUSTERNAME"
  echo "example: ${PROG_NAME} 10.168.1.66 myinfracluster"
  exit 0
fi

# {{{ do not override current configuration
if kubectl config view -o jsonpath="{ .clusters[?( @.name == \"${CLUSTERNAME}\" )].name }" | grep -q ${CLUSTERNAME}
then
  echo cluster ${CLUSTERNAME} is already configured in your \$KUBECONFIG
  echo please specify different name
  exit 1
fi

if kubectl config view -o jsonpath="{ .users[?( @.name == \"${CLUSTERNAME}\" )].name }" | grep -q ${CLUSTERNAME}
then
  echo user ${CLUSTERNAME} is already configured in your \$KUBECONFIG
  echo please specify different name
  exit 1
fi

if kubectl config view -o jsonpath="{ .contexts[?( @.name == \"${CLUSTERNAME}\" )].name }" | grep -q ${CLUSTERNAME}
then
  echo context ${CLUSTERNAME} is already configured in your \$KUBECONFIG
  echo please specify different name
  exit 1
fi
# }}}

# {{{ get config from remote node
WORKING_DIR=$(mktemp -d)
scp root@${1}:/etc/kubernetes/admin.conf ${WORKING_DIR}

# extract server address and certificate
CLUSTER_SERVER=$(kubectl --kubeconfig=${WORKING_DIR}/admin.conf config view -o jsonpath='{ .clusters[*].cluster.server }')
kubectl --kubeconfig=${WORKING_DIR}/admin.conf config view -o jsonpath='{ .clusters[*].cluster.certificate-authority-data }' --raw=true | base64 -d > ${WORKING_DIR}/certificate-authority
kubectl --kubeconfig=${WORKING_DIR}/admin.conf config view -o jsonpath='{ .users[*].user.client-certificate-data }' --raw=true | base64 -d > ${WORKING_DIR}/client-certificate
kubectl --kubeconfig=${WORKING_DIR}/admin.conf config view -o jsonpath='{ .users[*].user.client-key-data }' --raw=true | base64 -d > ${WORKING_DIR}/client-key
# }}}

# {{{ update kubeconfig
kubectl config set-credentials ${CLUSTERNAME} --client-certificate=${WORKING_DIR}/client-certificate --client-key=${WORKING_DIR}/client-key --embed-certs=true
kubectl config set-cluster ${CLUSTERNAME} --server=${CLUSTER_SERVER} --certificate-authority=${WORKING_DIR}/certificate-authority --embed-certs=true
kubectl config set-context ${CLUSTERNAME} --cluster=${CLUSTERNAME} --user=${CLUSTERNAME}

rm -rf ${WORKING_DIR}
# }}}

echo all done feel free to change the context by running
echo kubectl config use-context ${CLUSTERNAME}
