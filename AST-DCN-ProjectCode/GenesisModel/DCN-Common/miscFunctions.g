// GENESIS SETUP FILE
function setpulse_sine (cip_pA, freq, offset, pulseToUse)
  setfield {pulseToUse}		     	\
	mode 		1		\
	amplitude       {{cip_pA}*1e-12}\
	frequency       {freq}		\
	dc_offset	{{offset}*1e-12}		
    //echo {{offset}*1e-12}	
end

function setupClocks (simDt, outputDt, RUNDUR)
	setclock 0 {simDt}	// simulation
	setclock 1 {outputDt} 	// output 
end

function setupHinesSolver (cellpath)
	//silent -1
	setfield {cellpath} 						\
		path {cellpath}/##[][TYPE=compartment] 	\
        	comptmode       1 			\
        	chanmode        4 			\
        	calcmode        0 			\
        	outclock        1 			\
        	storemode       1
		call {cellpath} SETUP
		setmethod 11
end


function setupCurrentInjection_1comp (cellpath)
	create funcgen /pulseSoma
	setpulse_sine {0} {0} {0} {"/pulseSoma"}
	addmsg /pulseSoma {cellpath}/soma INJECT output
end



function setupHinesSolverIk (cellpath)
  setfield {cellpath}				\
  	path {cellpath}/##[][TYPE=compartment]	\
  	comptmode       1			\
  	chanmode        4			\
  	calcmode        1			\
  	outclock        1			\
  	storemode       1
  call {cellpath} SETUP
  setmethod 11
end
function setupHinesSolverGk (cellpath)
  setfield {cellpath}				\
  	path {cellpath}/##[][TYPE=compartment]	\
  	comptmode       1			\
  	chanmode        4			\
  	calcmode        1			\
  	outclock        1			\
  	storemode       2
  call {cellpath} SETUP
  setmethod 11
end

function doPreparations (cellpath, storemode)

  if ({storemode} == 1)
    setupHinesSolverIk /CN_cell
  elif ({storemode} == 2) //storemode: 1- currents 2-conductances
    setupHinesSolverGk /CN_cell
  end
  //reset

  create disk_out /out_v
  useclock /out_v 1
  setfield /out_v flush 0 append 0 leave_open 1
  str hstr = {findsolvefield {cellpath} {cellpath}/soma Vm}
  addmsg {cellpath} /out_v SAVE {hstr} //Vm
 
  addmsg {cellpath} /out_v SAVE itotal[23] //fmg_block
  addmsg {cellpath} /out_v SAVE itotal[25] //smg_block
  addmsg {cellpath} /out_v SAVE itotal[21] //AMPAd
  addmsg {cellpath} /out_v SAVE itotal[26] //GABAd
  addmsg {cellpath} /out_v SAVE itotal[41] //GABAs
  addmsg {cellpath}/soma/GABAs /out_v SAVE synapse[0].deprwt //STD


/*int currenti
  for (currenti = 0; currenti <= 41; currenti = currenti + 1)
    addmsg {cellpath} /out_v SAVE itotal[{currenti}]
  end
  */

end

//Grab spiketimes output - lifted from Nathan Schultheiss 
function grabSpiketimes (outpath)
        create neutral /DCNspiketimes
        create spikegen /DCNspiketimes/soma_spikegen

        setfield /DCNspiketimes/soma_spikegen        \
    output_amp 1 thresh 0 abs_refract .002
        hstr={findsolvefield {cellpath} {cellpath}/soma Vm}
        addmsg {cellpath} /DCNspiketimes/soma_spikegen INPUT {hstr}

        create spikehistory /DCNspiketimes/soma_spikehistory
                setfield /DCNspiketimes/soma_spikehistory    \
                        filename {{outpath} @ "spikehistory.asci"}    \
                        initialize 1 leave_open 1 flush 1 ident_toggle 1
 
        addmsg /DCNspiketimes/soma_spikegen /DCNspiketimes/soma_spikehistory SPIKESAVE
        call /DCNspiketimes/soma_spikehistory RESET
        echo {showfield /DCNspiketimes/soma_spikehistory *}
end
