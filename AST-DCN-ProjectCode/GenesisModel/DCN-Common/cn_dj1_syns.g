// GENESIS script: DCN model synaptic properties
// Created by D. Jaeger 10-22-05
// Modified from GPsyn.g  by Hanson and Edgerton
// Synaptic constants from cn6c_const_dj1.g
// Synaptic properties based on Gauck and Jaeger 2003 (JNS 23:8109).

function make_cn_syns
	if (!({exists AMPA}))
		create synchan AMPA
	end
	setfield AMPA Ek {E_AMPA} tau1 {tauRise_AMPA} tau2 {tauFall_AMPA} std_on 0\
    gmax 0 frequency 0 
	
if (!({exists fNMDA}))
                create synchan fNMDA
        end
	setfield fNMDA Ek {E_NMDA} tau1 {tauRise_fNMDA} tau2 {tauFall_fNMDA} std_on 0\
      gmax 0 frequency 0
	
	if (!({exists Mg_fblock}))
                create Mg_block Mg_fblock 
        end
	setfield Mg_fblock		\
		CMg    0.002		\
		KMg_A  1		\
		KMg_B  {1.0/{0.109*1000}}

	if (!({exists sNMDA}))
                create synchan sNMDA
        end
	setfield sNMDA Ek {E_NMDA} tau1 {tauRise_sNMDA} tau2 {tauFall_sNMDA} std_on 0\
		gmax 0 frequency 0
	
	if (!({exists Mg_sblock}))
                create Mg_block Mg_sblock 
        end
	setfield Mg_sblock		\
		CMg    0.25		\
		KMg_A  1		\
		KMg_B  {1/{0.057*1000}}

	if (!({exists GABA}))
	       	create synchan GABA
	end
	setfield GABA Ek {E_GABA} tau1 {tauRise_GABA} tau2 {tauFall_GABA}  std_on 1\
		gmax 0 frequency 0

end

