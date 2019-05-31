// GENESIS SETUP FILE
//07.02.2015 modified by Samira

silent -1

float rundur = 115.0
str modelName = "Steuber"

str spktime_dest_dir = "../ModelData/"
mkdir {spktime_dest_dir}

//initialize parameters
include ../DCN-Common/read_par_row_active.g
include ../DCN-Steuber/cn_const.g

/* COMMENT
ALL intrinsic model params have now been initialized and set. 
They can be safely overwritten any time between now and the calling of
the make_GP_library file. Once the library has been created, parameter values
are set and cannot be changed except with explicit calls to setfield.
*/

include ../DCN-Steuber/cn_chan.g 
include ../DCN-Common/cn_dj1_syns.g  	
include ../DCN-Common/cn_makesyns_full_AW.g
include ../DCN-Steuber/cn_comp
include ../DCN-Common/miscFunctions.g

int i
str tstr, hstr, readcompartment
setupClocks {1e-5} {1e-4} {rundur}
str basefilename = "PC"@{pcASTfolder}@"_pc"@{pcct}@"_mf"@{mfct}@"_gAMPA"@{g_ampa}@"_gGABA"@{g_gaba}@"_"@{modelName}@"_"

// make the prototypes in the library
if (!{exists /library})
  create neutral /library
  disable /library
end
ce /library
make_cn_chans
make_cn_syns
make_cn_comps

// read cell morphology from .p file
readcell ../DCN-Common/cn0106c_z15_l01_ax.p {cellpath} -hsolve


//
ce {cellpath}
add_soma_syns
add_dend_syns

ce soma
ce NaFs
setupCurrentInjection_1comp {cellpath}


//
doPreparations {cellpath} {2}
setfield /out_v filename {{spktime_dest_dir} @ {basefilename} @ "Vm.bin"}


//Grab spiketimes output - lifted from Nathan Schultheiss 
create neutral /DCNspiketimes
create spikegen /DCNspiketimes/soma_spikegen

setfield /DCNspiketimes/soma_spikegen        \
    output_amp 1 thresh 0 abs_refract .002
hstr={findsolvefield {cellpath} {cellpath}/soma Vm}
addmsg {cellpath} /DCNspiketimes/soma_spikegen INPUT {hstr}

create spikehistory /DCNspiketimes/soma_spikehistory
setfield /DCNspiketimes/soma_spikehistory    \
    filename {{spktime_dest_dir} @ {basefilename} @ "spikehistory.asci"}    \
    initialize 1 leave_open 1 flush 1 ident_toggle 1
 
addmsg /DCNspiketimes/soma_spikegen /DCNspiketimes/soma_spikehistory SPIKESAVE
call /DCNspiketimes/soma_spikehistory RESET
echo {showfield /DCNspiketimes/soma_spikehistory *}


//do current injections
str pulseToUse = "/pulseSoma"
str outdir = "../output"

//
setpulse_sine {0} {0} {0} {pulseToUse} 
reset
step {rundur} -time

//move_files
//mv {{spktime_dest_dir} @ {basefilename} @ "spikehistory.asci"} "./genesisFiles"
//mv {{spktime_dest_dir} @ {basefilename} @ "Vm.bin"} "./genesisFiles"

quit
