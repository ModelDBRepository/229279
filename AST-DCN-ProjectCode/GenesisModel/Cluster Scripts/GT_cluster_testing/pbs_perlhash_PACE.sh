#!/bin/bash

#PBS -N genesis_testrun
#PBS -j oe
#PBS -q tardis-debug-6
#PBS -l nodes=1:ppn=1
#PBS -l pmem=4gb
##PBS -m abe
##PBS -M aehudso@emory.edu

# Author: Cengiz Gunay <cgunay@emory.edu> 2005/06/29
# Modified by: Mehmet Belgin <mehmet.belgin@oit.gatech.edu> 2013/01/10
# Modified by: Amber Hudson <aehudso@emory.edu> 2014/05/28

trap exit INT
export PATH=/nv/het1/aehudso-emory/GT_Cluster_Testing/brute_scripts:$PATH


function usage()
{
   echo "Usage: "
   echo "qsub -t start-end -v genfile='genfilename',parfile='parfilename' pbs_perlhash_PACE.sh" 
   echo ""
   echo "E.g."
   echo "qsub -t 1-2 -v genfile='Main_cn_full_AW.g',parfile='fulltrial.par' pbs_perlhash_PACE.sh"
}

function errorout() { echo "$@" 1>&2; }

source $HOME/.bashrc
curdir=$PBS_O_WORKDIR
cd $curdir

if [ -z $genfile ] || [ -z $parfile ]; then
   errorout "Need to specify GENESIS script and parameter file."
   echo ""
   usage
   exit 1
fi

echo "Starting $PBS_JOBID ($PBS_JOBNAME)"
date
echo "GENESIS  script : ${genfile}"
echo "Parameter script: ${parfile}"
echo "Array ID        : ${PBS_ARRAYID}"
echo ""
echo "List of hosts: "
echo "=========================="
cat $PBS_NODEFILE
echo "=========================="

export GENESIS_PAR_ROW

# Read parameter values.
GENESIS_PAR_ROW=`dosimnum $parfile $PBS_ARRAYID`

[ "$?" != "0" ] && echo "Cannot read parameter row $PBS_ARRAYID, ending." && exit 1;

# Run genesis 
time genesis -nox -batch -notty $genfile

[ "$?" != "0" ] && echo "GENESIS run failed, terminating job!" && exit 1

echo "Ending job"
date












