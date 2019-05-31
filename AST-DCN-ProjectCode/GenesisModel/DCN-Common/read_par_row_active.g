// OBSOLETE with readParameters.g

if ({getenv GENESIS_PAR_ROW} == "")
  echo "*********************************************************************"
  echo "Error: This script needs to read the parameters from the environment "
  echo "        variable GENESIS_PAR_ROW. Set the variable prior to running"
  echo "        the script. Aborting simulation."
  echo "*********************************************************************"
  quit
end

str parrow = {getenv GENESIS_PAR_ROW}

echo "Parameter row: " {parrow}

float num_contact =  {getarg {arglist {parrow}} -arg 1}
float g_ampa =       {getarg {arglist {parrow}} -arg 2}
float g_gaba =       {getarg {arglist {parrow}} -arg 3}
float g_sks =        {getarg {arglist {parrow}} -arg 4}
float g_skd =        {getarg {arglist {parrow}} -arg 5}
int pcct =           {getarg {arglist {parrow}} -arg 6}
int mfct =           {getarg {arglist {parrow}} -arg 7}
str pcASTfolder =    {getarg {arglist {parrow}} -arg 8}
str mfASTfolder =    {getarg {arglist {parrow}} -arg 9}


//legacy options:
//int modulation_depth = 		{getarg {arglist {parrow}} -arg 1}
//str simDir = 		{getarg {arglist {parrow}} -arg 3}
//str mvDir = {simDir} @ "/genesisFiles"
//str basefilename =  "/var/tmp/this_run_" @ {trialnum}  
