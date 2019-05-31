%%------------------------------------------------
% Main script for generating a population of artifical spike trains
% the difference between this amd Main_ASTcreation.m is that here I added
% different gain for slow and fast rate fluctuations
%%------------------------------------------------
% Input (in parameters cell, below): 
%   -> Population statistics for biological data that you are trying to
%   reproduce in an artifical spike train population (matrix with columns: ??)
%   -> At least one PC spike train that does not have behavioral
%   modifications 
%   -> Peri-stimulus time histogram for behavioral response 
% Output: 
%   -> A collection of files is saved to the current directory, one for
%   each AST. Filenames are gammaspikes_{cellnum}_{ASTnum}.txt and content is spiketimes in seconds 
%   -> Population statistics are compared between biological data (input)
%   and the produced AST population 

%% MAIN Parameters
clear all; close all, clc

BehModFrac = [0.2,0.8];
BehModStren = [0.8,1.6];
ShiftFrac = [0.5, 1];
GainSlowFactor = [0, 0.5, 1.5, 2];
GainFastFactor = [0, 0.5, 1.5, 2];
for GS=1:length(GainSlowFactor)
    gain_slow_factor = GainSlowFactor(GS);
for GF=1:length(GainFastFactor)
    gain_fast_factor = GainFastFactor(GF);
for BMF=1:length(BehModFrac)
 % portion of ASTs with behavioral modulation
    ASTbehmodfraction=BehModFrac(BMF);
for BMS=1:length(BehModStren)
    BehModStrength = BehModStren(BMS);
for ShF=1:length(ShiftFrac)
% portion of final signal based on shifted signal 
shiftfraction=ShiftFrac(ShF);
% number of ASTs to produce
numAST = 50;
savedir = strcat('ASTgains','\','Shift',num2str(shiftfraction),'_BehMod',num2str(ASTbehmodfraction),'_BehModStrength',num2str(BehModStrength),...
    '_GainFa',num2str(gain_fast_factor),'_GainSa',num2str(gain_slow_factor));
mkdir(savedir);
addpath(savedir);
% bio population stats (numASTs, FR, LV, CVS, CVF, behmodfraction)
% popstat = makepoptargets(numAST, 66.82, 0.47, 0.31, 0.17, ASTbehmodfraction); %based on "representative" bio data #27
% popstat = makepoptargets(numAST, 80, 0.47, 0.24, 0.17, ASTbehmodfraction); %based on "representative" bio data #28
% popstat = makepoptargets(numAST, 84.76, 0.65, 0.34, 0.18, ASTbehmodfraction); %based on "representative" bio data #29
popstat = makepoptargets(numAST, 64.86, 0.5, 0.2, 0.19, ASTbehmodfraction); %based on "representative" bio data #30
% popstat = makepoptargets(numAST, 'dist', 0.5, 0.2, 0.19, ASTbehmodfraction);
% popstat = makepoptargets(numAST, 37.82, 0.86, 0.46, 0.34, ASTbehmodfraction); %based on "representative" bio data #31
% popstat = makepoptargets(numAST, 59.92, 0.28, 0.16, 0.08, ASTbehmodfraction); %based on "representative" bio data #32
% popstat = makepoptargets(numAST, 46.59, 0.51, 0.26, 0.15, ASTbehmodfraction); %based on "representative" bio data #34
% popstat = makepoptargets(numAST, 71.34, 0.94, 0.26, 0.21, ASTbehmodfraction); %based on "representative" bio data #37
% popstat = makepoptargets(numAST, 77.48, 0.43, 0.19, 0.21, ASTbehmodfraction); %based on "representative" bio data #42
% popstat = makepoptargets(numAST, 136.1, 0.46, 0.25, 0.24, ASTbehmodfraction); %based on "representative" bio data #43
% popstat = makepoptargets(numAST, 102, 0.31, 0.18, 0.08, ASTbehmodfraction); %based on "representative" bio data #44
% popstat = makepoptargets(numAST, 134.46, 0.36, 0.24, 0.08, ASTbehmodfraction); %based on "representative" bio data #45
% popstat = makepoptargets(numAST, 64.5, 0.44, 0.22, 0.13, ASTbehmodfraction);%bio data 46
% popstat = makepoptargets(numAST, 167.95, 0.48, 0.18, 0.12, ASTbehmodfraction);%bio data 47
% popstat = makepoptargets(numAST, 100.44, 0.56, 0.27, 0.23, ASTbehmodfraction);%bio data 48
% popstat = makepoptargets(numAST, 89.39, 0.74, 0.3, 0.26, ASTbehmodfraction); %based on "representative" bio data #49
% popstat = makepoptargets(numAST, 83.1, 0.49, 0.23, 0.13, ASTbehmodfraction); %based on "representative" bio data #51
% popstat = makepoptargets(numAST, 143.15, 0.67, 0.26, 0.31, ASTbehmodfraction); %based on "representative" bio data #52
% popstat = makepoptargets(numAST, 105.23, 0.89, 0.24, 0.12, ASTbehmodfraction); %based on "representative" bio data #82
% popstat = makepoptargets(numAST, 88.94, 0.73, 0.24, 0.12, ASTbehmodfraction); %based on "representative" bio data #83
% popstat = makepoptargets(numAST, 128.91, 0.67, 0.2, 0.1, ASTbehmodfraction); %based on "representative" bio data #86
%popstat = makepoptargets(numAST, 'dist', 'dist', 'dist','dist', ASTbehmodfraction); %bio based ranges
%popstat = makepoptargets(numAST, [50 120], 0.47, 0.24, 0.17, 0); %FR sweep
%popstat = load('aststats_HTsweep.txt'); % for hand-tuning population stats
save('astno_rate_lv_cvsl_cvft_psth.txt','popstat','-ascii');

% time units 
bio_t=0.0001; % conversion factor for input bio data - into seconds
desired_t=0.001; % desired units of ASTs (aka conversion factor for AST spiketimes to seconds)
win = 450;
order = 30;
% refractory period in seconds
refper = 0.003; 

% Which algorithm to use? 1:Selva (make sure filter=4) 2:UngammaForwardLooking (Filter=1) 3:GammaForwardLooking (filter=4)
algorithmflag=2;
% Smoothing of adaptive Gaussian rate estimate
filter = 1;

% plotting? y/n 1/0
plotflag = 0; 

%% Make ASTs 
for i= [30]%, 43] %[27:32,34,37,42:49,51,52,82,83,86] %28%
    %% Load bio data 
    
    % example bio spike times for initial rate estimate 
    fname=data_spt(i);
    sptimes=load(strcat(fname,'_refp3.txt'));   
        
    % corresponding event times 
    bevtfname=data_insp(i); %or data_exp(i);
    bevt=load(bevtfname)*bio_t; % convert to seconds  
  
    %% Get rate template from bio data 
    
    % Get fixed Gaussian estimate
    [fixedwinRate] = fixedGauss_FRest(sptimes,bio_t,plotflag,'.b'); 
       % Get adaptive Gaussian estimate
    [adapwinRate] = adaptGauss_FRest(sptimes,fixedwinRate,bio_t,filter,plotflag,'.r');
    
    % Loop for AST creation, given number of ASTs per base rate template     
    for j=1:numAST
%         Grab statistical targets for AST
        outputmean = popstat(j,2);
        reg = lv_kappa(popstat(j,3));
        gainsl = popstat(j,4);
        gainfa = popstat(j,5);   
        if popstat(j,6)==0 || BehModStrength==0
            psth = load('PSTH_flat.txt');
        else
            psth = load('PSTH_movavgorder_30_cellnum_43.txt');
            Mp = mean(psth);
            psth = psth - Mp;
            psth = psth * BehModStrength;
            psth = psth + Mp;
             
        end
        
%         add "noise" (shifted template) to rate template
            noisyfixrate=fixedwinRate; % these two lines were added by Samira
            noisyadaprate=adapwinRate;
        if ~(shiftfraction==0)
%             Get shifted version of rate function
            [shiftedf,shift]=templateshift(fixedwinRate(:,2)); %random shift
            [shifteda,~]=templateshift(adapwinRate(:,2),shift); %matches shift from fixedwinrate to make later processing easier 
            
%             Add in shifted signal
            noisyfixrate=fixedwinRate; %these two lines became comment by
%             Samira, because when shiftfraction=0 this is an error
            noisyadaprate=adapwinRate;
            noisyfixrate(:,2)=((1-shiftfraction)*fixedwinRate(:,2))+(shiftfraction*shiftedf);
            noisyadaprate(:,2)=((1-shiftfraction)*adapwinRate(:,2))+(shiftfraction*shifteda);
        end
%         measure CV for adjusted rate template (split by frequency)
        [adaptive,slow,templateCV_s, templateCV_f] = splitsignal_adjust(noisyfixrate,noisyadaprate,1,1,0);
    
%         adjust final templates with gain modulation 
        [FRadj,sl_FRadj,~,~] = splitsignal_adjust(noisyfixrate,noisyadaprate,gain_slow_factor*(gainsl/templateCV_s),gain_fast_factor*(gainfa/templateCV_f),shiftfraction,plotflag);

%       Create AST
        singleASTgen(savedir,ASTbehmodfraction,FRadj,bevt,outputmean,reg,refper,psth,algorithmflag,strcat(num2str(i),'_',num2str(j)));
    
    end
      
    % Compare AST pop stats to bio pop stats
%     compareASTs
    [bioStats, astStats] = bioVSast(num2cell(i),i, bio_t, numAST,savedir,1);
    savefig(strcat(savedir,'\','bar.fig'))
     close all
% 
end
end
end
end
end
end
