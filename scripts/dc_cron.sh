#!/bin/bash
#  script suitable for running from trscron invoking dc_register_harnessed.py
#
# Takes one argument: a database name (one of Prod, Dev, Test, Raw)
# and second optional argument: where to write log files

echo 'dc_register_cron.sh invoked at time'
date
export PYTHON_INST=/nfs/farm/g/lsst/u1/software/redhat6-x86_64-64bit-gcc44/anaconda/py-2.7.11
export PATH=${PYTHON_INST}/bin:${PATH}
export STACK_DIR=/nfs/farm/g/lsst/u1/software/redhat6-x86_64-64bit-gcc44/DMstack/v12_0

source activate ${STACK_DIR}
source ${STACK_DIR}/bin/eups-setups.sh
setup mysqlpython

export DATACAT_DIR=/afs/slac.stanford.edu/u/gl/srs/datacat/dev/0.5/lib
export PROGDIR=/nfs/farm/g/lsst/u/jrb/jrbTestJH/devSrc/eTraveler-frontend/python

if [ -z "${2}" ]; then
    export LOGDIR=${HOME}/lsst/dc_cron_logs
else
    export LOGDIR=${2}
fi

if [ -z "$PYTHONPATH" ]; then
    export PYTHONPATH=${DATACAT_DIR}
else
    export PYTHONPATH=${DATACAT_DIR}:${PYTHONPATH}
fi
now=`date -u +"%Y-%m-%d %T"`
nowT=`date -u +"%Y-%m-%dT%H%M%S"`

python ${PROGDIR}/dc_register_harnessed.py --db ${1} --end "${now}" >& ${LOGDIR}/${1}_${nowT}.log

