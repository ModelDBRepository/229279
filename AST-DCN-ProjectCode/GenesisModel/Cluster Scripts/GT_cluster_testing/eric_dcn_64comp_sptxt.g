// GENESIS SETUP FILE

silent -1

//int modulation_depth= 15
//float g_gaba = 11.76
//float g_ampa = 1.71
//float g_sks=2.0
//float g_skd=0.6
float rundur = 79
str modelName = "64comp"
//initialize parameters
//include ../../commonDCNred/actpars.g

include ../../commonDCNred/read_par_row_active.g
include ../../commonDCNred/cn6c_chanconst_dj26.g
include ../../commonDCNred/cn6c_pconst9.g
	
//str finame = "/home/selva/artificial_spike_trains/rate_dist_moddep_20_varreg_varnuminput/" @"rate_dist_reg" @ {reg} @ "_moddep_20_nummodinp_" @ {modulation_depth} @"_"@ {rept} @"/"
// echo {finame}

/* COMMENT
ALL intrinsic model params have now been initialized and set. 
They can be safely overwritten any time between now and the calling of
the make_GP_library file. Once the library has been created, parameter values
are set and cannot be changed except with explicit calls to setfield.
*/

include ../../commonDCNred/input_variation/cn6c_const_heck2_inputctvar.g
include  ../../commonDCNred/cn_chan_dj36.g 
include ../../commonDCNred/cn_dj1_syns.g  	
include ../../commonDCNred/input_variation/cn_makesyns_heck2_inputctvar.g
include ../../commonDCNred/cn_comp_dj10_cor.g
//include ../../commonDCNred/cn_fileout_dj5_bin
include ../../commonDCNred/ericsFunctions.g
//outfilesim = "/home/selva/ehendric_selva/dcnmodel/parameter_search_trial/parameter_search_dcn_trial_isihist/par_search_code/algorithms/matlabScripts/"



int i
str tstr, hstr, readcompartment
setupClocks {1e-5} {1e-3} {rundur}

// make the prototypes in the library
if (!{exists /library})
  create neutral /library
  disable /library
end
ce /library
make_cn_chans
make_cn_syns
make_cn_comps

//load compartments with ion channels
readcell ../../commonDCNred/dcn_64comp.p {cellpath} -hsolve

  create spikegen /CN_cell/soma/spike 
  setfield /CN_cell/soma/spike thresh 0 abs_refract 0.001 output_amp 1
  create asc_file /outasc_v1
  useclock /outasc_v1 1
  setfield /outasc_v1 flush 1 leave_open 1
  addmsg /CN_cell/soma/spike /outasc_v1 SAVE lastevent

ce {cellpath}
add_soma_syns
add_dend_syns

ce soma
ce NaFs
//showfield -a
//showmsg /CN_cell/p1[0] 
//showfield /CN_cell/p1[0]/AMPAd -a
setupCurrentInjection_1comp {cellpath}
setupHinesSolver {cellpath}

doPreparations {cellpath} {2}

//do current injections


str pulseToUse = "/pulseSoma"
str outdir = "../output"
//injectCurrent_saveLocally {-100} {pulseToUse} {cellpath} {modelName}
injectCurrent_saveLocally {0} {pulseToUse} {cellpath} {modulation_depth} {rept} {g_ampa} {g_gaba} {g_sks} {g_skd} {reg} {rundur} 
//injectCurrent_saveLocally {100} {pulseToUse} {cellpath} {modelName}
quit
