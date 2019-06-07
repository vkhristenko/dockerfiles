#!/bin/bash

DISTR=$1
RELEASE=$2
CONFIG=$3

# cms distr env setup
source ${DISTR}/cmsset_default.sh
cd ${DISTR}/${RELEASE}/src
eval `scramv1 runtime -sh`

cmsRun ${CONFIG}
