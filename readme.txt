README:  Cerebellar Nucleus (CN) Neuron modeling project.
Abbasi et. al.  PLOS Computational Biology 2017

A) There are 3 types of code:
1) Matlab code to prepare artificial spike trains (ASTs) as input to CN neuron model.  
2) CN model code to run different combinations of ASTs and model parameter settings.
3) Matlab code to analyze the simulation output files.

Note: a paperFigures folder is large and included separately from
https://senselab.med.yale.edu/modeldb/data/229279/paperFigures.zip
Please download and extract this zip file within the top level folder of this archive.

Re. 1)  The AST code is located in subdirectory AST-DCN-ProjectCode/ASTgeneration.  The main script is MAIN_ASTcreation.m.  
The recorded physiological spike trains that are used as templates are located in subdirectory NumberedData, where each number represents data from a recording session, including respiratory event times.  The spike trains of the recorded neurons come in 3 formats. 1) [name].txt.  The raw spike times in one column in units 0.1 ms, i.e. the number '30' is equivalent to 3 ms.  2) [name]_refp3.txt.   All spikes preceding a previous spike by less than 3 ms (the assumed absolute refractory period) are removed.  3) [name]_refp3_sub.txt.  The absolute refractory period of 3 ms between spike times is removed in order to generate the best match to a gamma distribution. 
The subdirectory AST-DCN_ProjectCode/ModelData includes a set of ASTs generated using our algorithm and also those same ASTs after removing the refractory period.

Re. 2) The CN model code is located under AST-DCN-ProjectCode/Genesis model.  The main script is located in DCN-Runs (Main_Samira.g).
'DCN-Common' directory contains common scripts of both model and 'DCN-Runs' contains main script to run the model.  Note that this model is an adaptation from our previously shared model available in ModelDB (Steuber, V., N. W. Schultheiss, R. A. Silver, E. De Schutter and D. Jaeger (2011). "Determinants of synaptic integration and heterogeneity in rebound firing explored with data driven models of deep cerebellar nucleus cells." Journal of Computational Neuroscience 30: 633-658.).  
Note:  The GENESIS simulator source code was changed in order to allow for the biologically correct formulation of the short-term plasticity rule for Purkinje cell input to the CN (see PLOS Comp. Biology paper).  In order to replicate our simulations exactly the source code for GENESIS needs to be recompiled with the changed synchan.c code.  The synchan object now has a field called std_on, which is set to 0 for a classical synchan, and to 1 for the CN specific STD rule.  The Genesis archive genesis2.3_std.zip in folder AST-DCN-ProjectCode/GenesisModel/GenesisSource contains this code in its src/newconn subfolder.  It also contains the precompiled nxgenesis_std executable, which may work on any given Linux machine (or not). 

Re. 3) The analysis code is primarily located in subfolder paperFigures/AnalysisScripts.  Some custom code may also be in each Figure directory, and the analysis code draws from the chronux toolbox (http://chronux.org/)  (copy of the version used here provided in chronux subdirectory). See section C) below for more detail.  
Our analysis strategy uses the database approach published by Cengiz Gunay (Gunay, C., J. R. Edgerton, S. Li, T. Sangrey, A. A. Prinz and D. Jaeger (2009). "Database Analysis of Simulated and Recorded Electrophysiological Datasets with PANDORA's Toolbox." Neuroinformatics 7(2): 93-111.) and available under https://github.com/cengique/pandora-matlab.   We include a copy of the version we used here under 'pandora-matlab-1.4compat2':

B) The figures from the publication can be reproduced from the paperFigures subdirectory.  
Note, however, that figure panels were post-processed with Adobe Illustrator and axis labels, colors, and dot sizes in raster plots for example will not match the published figures.  
Before running the .m files from each figure directory, please add the root codes directory with all subdirectories to your Matlab path. 
Figure 1:
- 'figure1_A_B_C_D.m':  this script plots panels A to D of figure 1.
- 'figure1_E_F.m':  this script plots panels E to F of figure 1.

Figure 2:
This figure compares original and improved DCN model for Gex = 2 and Gin = 6.
- 'figure2_A_B.m':  this script plots panels A to B of figure 2.
- 'figure2_C_D_E_F.m':  this script plots panels C to F of figure 2.
- 'DatabaseGeneration.m': this script creates database for simulated DCN outputs. Its output is 'figure2_db'.

Figure 3:
This figure shows FR vs Gex and CV and LV vs FR for DCN simulations.
- 'Figure3.m': this script plots panels of figure 3.
Figure 4:
This figure shows CV vs FR and LV vs CV for recorded DCN data and simulations results.
- 'figure4.m': this script plots panels of figure 4.
Figure 5:
This figure shows input and output PSTHs and respiratory raster plots for recorded and simulated PC and DCN.
- 'figure5.m': this script plots panels of figure 5.
- 'codes\AST-DCN-ProjectCode\ModelData\ASTcell30withFRfromCell43\Shift0_BehMod1_BehModStrength1': ASTs in this directory are used in figure 5.

Figure 6:
This figure shows PSTHs for low and high Gex for three values of Behavior Modulation Strength (BMS), also it shows CV, LV and change in mean PSTH peak frequency vs BMS for different values of Behavior Modulation Fraction (BMF), Gex and Shift Fraction.
- 'figure6_A.m':  this script plots panel A of figure 6.
- 'figure6_B_C_D.m':  this script plots panels B to D of figure 6.

Figure 7:
This figure shows results of simulation with 500 ASTs, and also differences between these results and simulation results with 50 ASTs.
- 'figure7_A.m':  this script plots panel A of figure 7.
- 'figure7_B_C_E_F.m':  this script plots panels B to C and E to F of figure 7.
- 'figure7_D.m':  this script plots panel D of figure 7.
Figure 8:
This figure shows results of simulations with different values of SK conductance. 
- 'figure8_A.m':  this script plots panel A of figure 8.
- 'figure8_B_C_D_F.m':  this script plots panels B to D and F of figure 8.
- 'figure8_E.m':  this script plots panel E of figure 8.
Supplemental Figure 1:
This figure shows spike train statistics of recorded neurons.
'SuppFigure1.m': this script plots figure S1.
Supplemental Figure 2:
This figure shows PSTHs and respiratory cycles for MFs, PCs, and DCNs.
- 'SuppFigure2.m': this script plots panels of figure S2.

Supplemental Figure 3:
This figure shows PSTH population properties.
- 'SuppFigure3.m': this script plots panels of figure S3.

Supplemental Figure 4:
This figure shows results for simulation without STD (std off), and also differences between std off and on.
- 'SuppFigure4.m': this script plots figure S4.
Supplemental Figure 5:
This figure shows results of simulation with ASTs constructed with half value of original firing rate, and also differences between these results and original results.
- 'SuppFigure5_A.m': this script plots panel A of figure S5.
- 'SuppFigure5_B.m': this script plots panel B of figure S5.
- 'SuppFigure5_C_D_E_F.m': this script plots panels C to F of figure S5.

Supplemental Figure 6:
This figure shows results of simulation with ASTs constructed with twice value of original firing rate, and also differences between these results and original results.
- 'SuppFigure 6_A.m': this script plots panel A of figure S6.
- 'SuppFigure 6.m': this script plots panel B of figure S6.
- 'SuppFigure 6_C_D_E_F.m': this script plots panels C to F of figure S6.

Supplemental Figure 7:
This figure shows results of simulations with ASTs constructed from recorded firing rate distribution. It also shows differences between original simulations and current results.
Firing rate distribution used to construct ASTs= 50:25:175
- 'SuppFigure7_A.m': this script plots panel A of figure S7.
- 'SuppFigure7_B.m': this script plots panel B of figure S7.
- 'SuppFigure7_C_D_E_F.m': this script plots panels C to F of figure S7.

Supplemental Figure 8:
This figure shows results of simulations with ASTs from different recorded PC (cell with lower CV). It also demonstrates differences between original simulations and current simulations.
- 'SuppFigure8_A.m': this script plots panel A of figure S8.
- 'SuppFigure8_B.m': this script plots panel B of figure S8.
- 'SuppFigure8_C_D_E_F.m': this script plots panels C to F of figure S8.

Supplemental Figure 9:
This figure shows results of simulation with manipulation of slow and fast rate template.
SRM: slow rate modulation
FRM: fast rate modulation
- 'SuppFigure9.m': this script plots panels of figure S9.



C) 'AnalysisScripts' directory: 
This directory includes functions and scripts required to do simulations and plot figures. It also includes codes to make databases from simulation output of DCN model and generated databases. For making a database one deals with the following parameters i.e. you must change them according to your desire database:
- 'filesetGenesisAnalysis.m': 
In this mfile one finds: 
start_time = 0; 
end_time = 110;
These are start and end time of spike times that you want to use in your analysis to make a database.
- 'GenesisOutputAnalysis.m':
This script is the main script to make a database. In this script one must change the following parameters according to each database:
nums : this is the recorded PC ID that you used for generating ASTs (for example I used PC numbered 30). It is used to load behavior event times to calculate PSTH.
DCNmodel_rundur: genesis run duration is second (in our simulations it was 110)
ASTnums: number of ASTs (50 or 500)
- 'getPSTHsDCN.m':
This script calculates PSTH. You must determine directory of your ASTs in "base". For example:
These were parameters that one should pay attention to them for making a database. Then to make a database there is script entitled "DatabaseGeneration.m". By running this mfile one can make a database. 
Databases which were made from different batches of simulations are placed in this directory and explanation of them goes here:
"ParamFile1_db": this was made from results of the first batch of simulations using the following values for the parameters:
num_contact: number of contacts in DCN model, g_ampa : ampa conductance, g_gaba: gaba conductance, g_sks: somatic SK channel conductance, g_skd: dendritic SK channel conductance, pcct: number of PCs synapses on the DCN model dendrites, mfct: number of MFs synapses on the DCN model dendrites,  mfASTfolder: ID identifying directory of MF ASTs, ShiftFrac: shift fraction parameter in the AST generation algorithm, BehMod: behavior modulation parameter in the AST generation algorithm.
num_contact [ 1 ]  
g_ampa [ 0 1 2 3 4 5 6 7 8 9 10 ]  
g_gaba [ 0 2 4 6 8 10 12 14 16 18 20 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0:0.25: 1 ] 
BehMod [ 0 ]
'
"ParamFile2_db":
This is results of simulations with adding behavior modulation. These simulations were run with two values of g-gaba and two values of g-ampa for each g-gaba.
1)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 16 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 ]
BehModStrength [ 0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2]
2)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 4 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 ]
BehModStrength [ 0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2]
'
'std_off_db':
This is previous simulations but without STD.
1)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 7.2 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 ]
BehModStrength [ 0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2]
2)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 1.8 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 ]
BehModStrength [ 0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2]
'
'FR_twice_half_db':
This is simulations with ASTs constructed with twice and half values of original FR. 
1. FR twice
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 8 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
2. FR twice
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [2 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
3. FR half
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 32 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
4. FR half
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [8 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
'
After this set of simulations we realized that we should modify g-gaba. So, I ran this set with modifies values for g-gaba. Results are in the following directory:
'NewFR_twice_half_db':
1. FR twice
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 9.84 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
2. FR twice
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [2.46 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
3. FR half
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 27.52 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
4. FR half
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [6.88 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
'
' SK_db.mat':
This is simulations with different values of SK conductances.
1)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 16 ]  
g_sks [ 0 ]  
g_skd [ 0 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
2)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 4 ]  
g_sks [ 0 ]  
g_skd [ 0 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
3)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 16 ]  
g_sks [ 0.5 ]  
g_skd [ 0.15 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
4)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 4 ]  
g_sks [ 0.5 ]  
g_skd [ 0.15 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
5)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 16 ]  
g_sks [ 4 ]  
g_skd [ 1.2 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
6)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 4 ]  
g_sks [ 4 ]  
g_skd [ 1.2 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
7)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 16 ]  
g_sks [ 8 ]  
g_skd [ 2.4 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
8)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 4 ]  
g_sks [ 8 ]  
g_skd [ 2.4 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
'
 ' modifyFRdistribution_db.mat':
This is simulations with ASTs constructed from recorded PC firing rate distribution. 
1)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 12.37 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
2)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 3.1 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]
'
'AST500_db.mat':
This is simulations with 500 ASTs.
1)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 1.6 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 480 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0 0.2 0.4 0.6 0.8 1 ]
BehModStrength [ 0 0.4 0.8 1.2 1.6 2 ]
2)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 0.4 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 480 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0 0.2 0.4 0.6 0.8 1 ]
BehModStrength [ 0 0.4 0.8 1.2 1.6 2 ]
'
 'gains_db.mat':
This is simulations with different values of slow and fast rate modulation gains.
1)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 16 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0.2 0.8 ]
BehModStrength [ 0.8 1.6 ]
GainFa [0 0.5 1.5 2]
GainSa [0 0.5 1.5 2]
2)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 4 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0.2 0.8 ]
BehModStrength [ 0.8 1.6]
GainFa [0 0.5 1.5 2]
GainSa [0 0.5 1.5 2]
 
 'cell32_db.mat':
This is results of simulations with ASTs constructed from recorded PC with lower CV.
1)
num_contact [ 1 ]  
g_ampa [ 3.5 6 ]  
g_gaba [ 16 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4 0.8  1.2  1.6  2]
2)
num_contact [ 1 ]  
g_ampa [ 1.1 2.15 ]  
g_gaba [ 4 ]  
g_sks [ 2 ]  
g_skd [ 0.6 ]  
pcct [ 48 ]  
mfct [ 48 ]  
mfASTfolder [ 1 ]  
ShiftFrac [ 0.5 1 ] 
BehMod [ 0  0.2  0.4  0.6  0.8  1 ]
BehModStrength [ 0  0.4  0.8  1.2  1.6  2]

'FR50HZ-175HzResults':
This directory contains some of the simulation results used to plot figure 2.


D) 'AST-DCN-ProjectCode' directory:
This directory includes 3 subdirectory as follows:
'ASTgeneration': 
- This directory contains functions and scripts required to generate ASTs population and 'MAIN_ASTcreation.m' is the main script for generating ASTs and in this script one should set the following parameters:
* BehModFrac: fraction of ASTs which have behavior modulation, its range is [0-1]
* BehModStren: strength of added behavior modulation or its amplitude
* ShiftFrac : fraction of shifted rate template to make noisy template, its range is [0-1]
* numAST: number of ASTSs you are going to generate.
* Savedir: directory to save ASTs
* i: ID of recorded PC, we used cell number 30 if you are going to use another cell you must change it. And also change "popstat" according to your desire.

