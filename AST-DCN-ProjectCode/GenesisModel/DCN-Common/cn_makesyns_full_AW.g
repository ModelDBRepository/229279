// Genesis
// D. Jaeger 10/15/08
// to be used for cn6c DCN simulation
// synaptic input from spike time files
// edited by AE Willett 2014

// add inhib synapses to soma
function add_soma_syns

  copy /library/GABA soma/GABAs
  setfield soma/GABAs gmax {G_GABAs}
  addmsg soma/GABAs soma CHANNEL Gk Ek
  addmsg soma soma/GABAs VOLTAGE Vm	

  //set up timetables and input to soma
  if (!{exists /inputs})
    create neutral /inputs
  end

  str finame
  create neutral /inputs/soma
  randseed 345678
  
  for(i=49; i<=50; i=i+1)
	  finame = "../AST/PC" @ {pcASTfolder} @ "/" @ {PC_spkti} @ {i} @ ".txt"  
	  create timetable /inputs/soma/inhib_tt{i}
    setfield /inputs/soma/inhib_tt{i} \
    maxtime {rundur} act_val 1.0 method 4 fname {finame}
    call /inputs/soma/inhib_tt{i} TABFILL
    create spikegen /inputs/soma/inhib_spikegen{i}
    setfield /inputs/soma/inhib_spikegen{i} output_amp 1 thresh 0.5
    addmsg /inputs/soma/inhib_tt{i} /inputs/soma/inhib_spikegen{i} INPUT activation
    addmsg /inputs/soma/inhib_spikegen{i} soma/GABAs SPIKE
	  setfield soma/GABAs synapse[{i-49}].weight 1.0 synapse[{i-49}].delay 0.00001 synapse[{i-49}].preinput_t -1000.0 synapse[{i-49}].Rec_n 1 synapse[{i-49}].Rec_pre 1
  end
end

function add_dend_syns

	int i,j, astnum, numinputs
	str mfincomp, pcincomp,num_comp_mf, num_comp_pc,tot_inp_cp_mf, tot_inp_cp_pc,sort_inp_mf,sort_inp_pc
	str finame

	if (!{exists /inputs})
 	 create neutral /inputs
	end 
	
  // add excitatory synapses to set of compartments from file
  openfile {MF_infile} r
  openfile {tot_input_comp_mf} r
	randseed {MF_seed}
        		
  for (j = 1; j <= {no_comp}; j = j + 1)                      
    mfincomp = {readfile {MF_infile}}                         // name of compartment
    tot_inp_cp_mf = {readfile {tot_input_comp_mf}}            // list of inputs for this compartment
    numinputs = {getarg {arglist {tot_inp_cp_mf}} -count}     // number of inputs for this compartment
    if( {getarg {arglist {tot_inp_cp_mf}} -arg 1} > 0 )       // if no inputs in compartment, put 0 in txt file
      copy /library/AMPA {mfincomp}/AMPAd
      setfield {mfincomp}/AMPAd gmax {G_AMPAd}
      addmsg  {mfincomp}/AMPAd {mfincomp}  CHANNEL Gk Ek
      addmsg  {mfincomp} {mfincomp}/AMPAd VOLTAGE Vm
      copy /library/fNMDA {mfincomp}/fNMDAd
      setfield {mfincomp}/fNMDAd gmax {G_fNMDAd}
      copy /library/Mg_fblock {mfincomp}/Mg_fblockd
      addmsg {mfincomp}/fNMDAd {mfincomp}/Mg_fblockd CHANNEL Gk Ek
      addmsg {mfincomp}/Mg_fblockd {mfincomp} CHANNEL Gk Ek
      addmsg {mfincomp} {mfincomp}/Mg_fblockd VOLTAGE Vm	
      addmsg {mfincomp} {mfincomp}/fNMDAd VOLTAGE Vm	
      copy /library/sNMDA {mfincomp}/sNMDAd
      setfield {mfincomp}/sNMDAd gmax {G_sNMDAd}
      copy /library/Mg_sblock {mfincomp}/Mg_sblockd
      addmsg {mfincomp}/sNMDAd {mfincomp}/Mg_sblockd CHANNEL Gk Ek
      addmsg {mfincomp}/Mg_sblockd {mfincomp} CHANNEL Gk Ek
      addmsg {mfincomp} {mfincomp}/Mg_sblockd VOLTAGE Vm	
      addmsg {mfincomp} {mfincomp}/sNMDAd VOLTAGE Vm	
      if(!{exists /inputs/{mfincomp}}) 
        create neutral /inputs/{mfincomp}
      end           
            
      for (i = 1; i <= {numinputs}; i = i + 1)
				astnum = {getarg {arglist {tot_inp_cp_mf}} -arg {i}} 
        finame = "../AST/MF" @ {mfASTfolder} @ "/" @ {MF_spkti} @ {astnum} @ ".txt"
                
				create timetable /inputs/{mfincomp}/ex_tt{i}
        setfield /inputs/{mfincomp}/ex_tt{i} \
          maxtime {rundur} act_val 1.0 method 4 fname {finame}
        call /inputs/{mfincomp}/ex_tt{i} TABFILL
        create spikegen /inputs/{mfincomp}/ex_spikegen{i}
        setfield /inputs/{mfincomp}/ex_spikegen{i} output_amp 1 thresh 0.5
        addmsg /inputs/{mfincomp}/ex_tt{i} /inputs/{mfincomp}/ex_spikegen{i} INPUT activation
        addmsg /inputs/{mfincomp}/ex_spikegen{i} {mfincomp}/AMPAd SPIKE
        addmsg /inputs/{mfincomp}/ex_spikegen{i} {mfincomp}/fNMDAd SPIKE
        addmsg /inputs/{mfincomp}/ex_spikegen{i} {mfincomp}/sNMDAd SPIKE
      end
    end
  end
	
  closefile {MF_infile}
  closefile {tot_input_comp_mf}

	// add inhibitory synapses to all or a subset of compartments
  openfile {PC_infile} r 
  openfile {tot_input_comp_pc} r
	randseed {PC_seed}

  for (j = 1; j <= {no_comp}; j = j + 1)   
    pcincomp = {readfile {PC_infile}}
    tot_inp_cp_pc = {readfile {tot_input_comp_pc} -l}  
    numinputs = {getarg {arglist {tot_inp_cp_pc}} -count}        
    if( {getarg {arglist {tot_inp_cp_pc}} -arg 1} > 0 ) 
      copy /library/GABA {pcincomp}/GABAd
      setfield {pcincomp}/GABAd gmax {G_GABAd}
      addmsg  {pcincomp}/GABAd {pcincomp}  CHANNEL Gk Ek
      addmsg  {pcincomp} {pcincomp}/GABAd VOLTAGE Vm			
      if(!{exists /inputs/{pcincomp}}) 
        create neutral /inputs/{pcincomp}
      end

      for (i = 1; i <= {numinputs}; i = i + 1)  
        astnum = {getarg {arglist {tot_inp_cp_pc}} -arg {i}} 
        finame = "../AST/PC" @ {pcASTfolder} @ "/" @ {PC_spkti} @ {astnum} @ ".txt"
		
        create timetable /inputs/{pcincomp}/inhib_tt{i}
        setfield /inputs/{pcincomp}/inhib_tt{i} \
        maxtime {rundur} act_val 1.0 method 4 fname {finame}
        call /inputs/{pcincomp}/inhib_tt{i} TABFILL
        create spikegen /inputs/{pcincomp}/inhib_spikegen{i}
        setfield /inputs/{pcincomp}/inhib_spikegen{i} output_amp 1 thresh 0.5
        addmsg /inputs/{pcincomp}/inhib_tt{i} /inputs/{pcincomp}/inhib_spikegen{i} INPUT activation
        addmsg /inputs/{pcincomp}/inhib_spikegen{i} {pcincomp}/GABAd SPIKE
        setfield {pcincomp}/GABAd synapse[{i-1}].weight 1.0 synapse[{i-1}].delay 0.000001 synapse[{i-1}].preinput_t -1000.0 synapse[{i-1}].Rec_n 1 synapse[{i-1}].Rec_pre 1
      end
    end
  end
  
	closefile {PC_infile}
  closefile {tot_input_comp_pc}
  
end
