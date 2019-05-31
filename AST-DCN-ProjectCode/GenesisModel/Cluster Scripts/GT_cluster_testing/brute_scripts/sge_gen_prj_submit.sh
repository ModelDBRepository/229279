#! /bin/bash

# Script to submit an array job to SGE based on a parameter file.

if [ -z $3 ]; then
	echo "Usage: "
	echo "	$0 my_genesis_script.g my_params.par master_project_file [options-to-qsub]"
	echo "(Run in the script directory.)"
	exit -1;
fi

genfile=$1
parfile=$2
prjfile=$3
shift 3

# Read last line from project file
if [ -r $prjfile ]; then
	start_from=`tail -1 $prjfile | cut -d\  -f3`
else
	start_from=0
fi

# Get the number of trials from the parameter file
trials=`head -1 $parfile | cut -d " " -f 1` 
#awk 'BEGIN{ getline; print $1}'`

echo "GENESIS script: $genfile; param. file: $parfile with $trials trials."
echo

create_perlhash_param_db $parfile
echo 
qsub -t 1:$trials $* /home/jaegerlab/brute_scripts/sge_gen_prjname.sh $genfile $parfile $start_from $prjfile

# Update project file with new information
echo "$parfile $trials $[ $start_from + $trials ] `date +"%F_%H:%M"`" >> $prjfile
