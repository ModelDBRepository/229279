#!/bin/bash

#PBS -N sge_run
#PBS -j oe
#PBS -q emory
#PBS -l nodes=1:ppn=1
#PBS -l pmem=4gb
##PBS -m abe
##PBS -M <your email here>

trap exit INT

function usage()
{
   echo "Usage: "
   echo "qsub -t start-end -v genfile="genfilename",parfile="parfilename" memo_submit_job.sh" 
   echo "E.g."
   echo "qsub -t start-end -v genfile="genfilename",parfile="parfilename" memo_submit_job.sh"
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
time nxgenesis_std -nox -batch -notty $genfile

[ "$?" != "0" ] && echo "GENESIS run failed, terminating job!" && exit 1

echo "Ending job"
date












