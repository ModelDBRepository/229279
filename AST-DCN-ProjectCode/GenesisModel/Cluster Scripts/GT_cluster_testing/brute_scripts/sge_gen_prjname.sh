#! /bin/bash

#$ -cwd
#$ -j y
#$ -N sge_run
#$ -S /bin/bash

# This sge job script reads a designated row from the parameter file and executes
# genesis to process it. It uses a fast hashtable access to read the parameter 
# row from a database created with the create_perlhash_param_db script.
# Notice that, this script does not mark the row as processed in the original 
# parameter file. One needs to use checkMissing.pl script to find out which 
# rows are already done.
# The reason this script does not modify the parameter file is to avoid
# race conditions that occur when writing to the parameter file concurrently.

# Author: Cengiz Gunay <cgunay@emory.edu> 2005/06/29
# $Id: sge_perlhash.sh,v 1.3 2005/10/26 17:29:26 cengiz Exp $

# Run this with:
# qsub -t 1:1310 ~/brute_scripts/sge_perlhash.sh setup_cip_act_handtune.g blocked_gps0501-03_2.par

# Need to source our own rc file. >:O
source $HOME/.bashrc

curdir=`pwd`

echo "Starting job $SGE_TASK_ID/$SGE_TASK_LAST on $HOSTNAME"
date

if [ -z "$3" ]; then
   echo "Need to specify GENESIS script and parameter file."
   echo ""
   echo "Usage: "
   echo "   $0 genesis_script parameter_file starting_number"
   exit -1
fi

trap exit INT

genfile=$1
parfile=$2
start_from=$3
prj_file=$4

# Special check for cluster traps
#if [ $HOSTNAME == "work46" ]; then 
#	echo "I don't like work46, it doesn't have the perl libraries I need. I'm going to take a nap now."
#	sleep $[60 * 60 * 24 * 3]	# Sleep for 3 days
#	exit -1
#fi

export GENESIS_PAR_ROW

# Random delay to avoid deadlock only for the first batch of nodes
# Afterwards, the offsets should be preserved.
if [[ $SGE_TASK_ID < 126 ]]; then
   awk 'BEGIN {system("sleep " rand() * 20)}'
fi

# Read parameter values.
GENESIS_PAR_ROW=`dosimnum $parfile $SGE_TASK_ID`

[ "$?" != "0" ] && echo "Cannot read parameter row $SGE_TASK_ID, ending." && exit -1;

# data file prefix
file_prefix="${SGE_TASK_ID}_${parfile%%.par}_$[ $SGE_TASK_ID + $start_from ]_${prj_file}"

# Append to parameter row
GENESIS_PAR_ROW="$GENESIS_PAR_ROW $file_prefix"

# Run genesis 
time genesis -nox -batch -notty $genfile

[ "$?" != "0" ] && echo "GENESIS run failed, terminating job!" && exit -1

echo "Ending job"
date

