#!/bin/bash

DISTR=$1
RELEASE=$2

echo "setting up release ${RELEASE}"

# cms distr
source ${DISTR}/cmsset_default.sh

# checkout a release and set envs
scram project ${RELEASE}
SRC=${DISTR}/${RELEASE}/src
cd ${SRC}
eval `scramv1 runtime -sh`

# initialize and merge branch, and compile
git cms-init -y -x cms-patatrack
git branch CMSSW_10_6_X_Patatrack --track cms-patatrack/CMSSW_10_6_X_Patatrack
git cms-merge-topic vkhristenko:ecal_dev_patatrack_1
scram b -v -j 8
