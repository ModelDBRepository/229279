Author:  Dieter Jaeger
Date: 5/10/2015 rev 1

DCN simulation files for CRCNS project: In vivo AST evaluation with full model.

Root Directory:
GenesisModel/DCN-Full


Root simulation file (master):
This name may vary.  Current:  
1) Main_cn_full_AW.g
	This script includes all other scripts, calls the needed functions to construct the libraries, and then reads the cell morphology into the hines solver.  It also declares the data filename, steps the simulation and moves the files.  
	
NOTES:  a) The directory structure for file saving probably needs updating for Tardis! (Cengiz?). There are other aspects of this script that may need updating.  b) One of the latest additions to the script is the creation of spiketimes output. 


2) ../DCN-Common/read_par_row_active.g
	This script reads the flexible parameters from the environment variable GENESIS_PAR_ROW.  This includes synaptic parameters such as g_gaba, number of mossy and purkinje cell inputs, and importantly the location of the ASTs as a folder.  
NOTES:  a) In previous versions of the model the functionality of this .g file was included in the main script.  
b) the settings of the parameters are placed in the filename for later parsing by matlab - they are otherwise not retrievable. The filename is set in the master script. The filename content have to be adjusted based on what parameters are held flexible in a given set of simulations. 

NOTES:  This script probably needs updating based on Cengiz' new cluster scripts.  (Cengiz?)

3) cn_chanconst_full.g
	It should need no further changes.  It declares the channel density parameter names, and some other parameters related to synaptic input.  It also assignes default values for these parameter.  These defaults correspond to the published DCN models, but could be overwritten with input from the GENESIS_PAR_ROW content. Needs to be included before channel library is built. 
This script SHOULD be placed in DCN-Common.  

4) ../ DCN-Common/cn6c_pconst9.g
	This script declares the passive membrane parameters for the simulation and sets defaults.  It should generally not be touched. Needs to be included before compartment library is built. 


5) cn_const_full.g 
	This script declares additional default parameters such as synaptic time constants and ionic concentrations.  It should generally not be touched. Needs to be included before synapse and compartment libraries are built. This script SHOULD be placed in DCN-Common.  

IMPORTANT:  Towards the end this script defines the names of the AST input files that are expected, as well as the textfiles that contain the list of compartments that receive synapses.  Right now, the PC input compartments are set in PC_infile and tot_input_comp_pc.  PC_infile is set to  "cn_dendcomps.txt", which contains a list of ALL dendritic compartments.  tot_input_comp_pc is read from "pccomps_" @ {pcct} @ "input_" @ {num_contact} @ "buton_fullmodel.txt".  This may be unnecesarily complicated.  Certainly this file needs to be constructed. These files later are needed in function 'add_soma_syns' and 'add_dend_syns' located in cn_makesyns_full_AW.g. [This all might be improved].

	

6) ../DCN-Common/cn_chan_dj36.g 
	This script contains the different functions that each make one prototype channel for the library, such as NaF. Then it contains the function make_cn_chans, which makes all channels. This script should generally not be touched. 


7) ../DCN-Common/cn_dj1_syns.g  
	This script contains the make_cn_syns function that creates the default library synapse types.  It should generally not be touched. 


8) cn_makesyns_full_AW.g
	This script contains the functions add_soma_syns and add_dend_syns to create the synapses on the library compartments.  The functions need to be called after the make_cn_syns and make_cn_comps are called.

IMPORTANT:  The Purkinje cell (PC) inputs are either individually put on a selected set of compartments, i.e. there is one active zone (called bouton) per input.  Alternatively, each input is distributed across 25 compartments with 25 active zones (boutons).  This distribution occurs in the file indexed by 'tot_input_comp_pc'

NOTES:  a) This script is under construction and probably contains bugs !!  In particular the name 'soma' should probably be CN_soma instead, as declared in make_cn_comps. b) This script needs to be carefully checked to put the right number of synpases in the right number of places.  It should be 50 PC synapses.  Looks like #50 is put in the soma, so that 49 remain for the dendrites. 


9) ../DCN-Common/cn_comp_dj10_cor.g
	This script contains the function make_cn_comps that creates the library prototype compartments.  It places the channels into the prototype compartments, but NOT the synpases.
NOTES:  The header comments are inaccurate. Soma synapses are no longer added here. 


10) miscFunctions.g
	Contains a variety of functions:
	a) setupHinesSolver // this function could just as well be spelled out fully in the master script (it used to be).
	b) setpulse_sine // not needed most of the time
	c) setupClocks // this function could just as well be spelled out fully in the master script - just 2 lines
	d) setupCurrentInjection // not needed most of the time for our project
	e) doPreparations
		NOTES:  HORRIBLE NAME.  It is used mostly to determine which variables are saved to file.  As such, this will need adjustment based on what model output we need to look at for a given subset of simulations.  I much recommend renaming this script. In the original model this functionaly was contained in an addtional .g file named 'cn_fileout_dj4.g' (and other version), which had separate functions for saving voltage, channel and synaptic information to files.  These functions were then called from the master script.  I recommend reverting to this strategy and doing away with doPreparations.  It is one of Selva's hacks and not transparent as to functionality nor flexible in terms of what is saved.  I am putting a copy of my old cn_fileout_dj4.g in our shared DCN-common development folder on Box. 

		


