function [ spt2 ] = spiketrains_refp_subt(sptimes,deltat,refp,savedir,write_flag)
%SPIKETRAINS_REFP_SUBT 
% Function to remove spiketimes less than specified refp1 (in seconds) from spiketrain
% Also subtracts refp1 from each interspike interval
% Returns spiketimes in seconds
% Input:    
%   sptimes - spiketimes in units deltat (can be filename to load or matrix) 
%   deltat - units for spiketimes (i.e. a multiplier that will convert spiketimes to seconds) 
%   refp - refractory period 
%savedir: directory to save gammaspikes
%   write_flag - 1 to save new spiketrain to text file. Requires sptimes to be a filename 


if (isstr(sptimes))
%     spt=load(sptimes).*deltat;
spt=load(strcat(savedir,'\',sptimes)).*deltat;
else
    spt=sptimes.*deltat;
end

% Remove short ISIs by removing spiketimes less than refp from previous spiketime
ISIs = diff(spt);
shortISIs = find(ISIs<=refp);
spt(shortISIs+1)=[];

% Subtract refp from each ISI
ISIs = diff(spt);
ISIs = ISIs - refp; 
spt2 = cumsum([spt(1); ISIs]);


%%
if(write_flag==1)
    sptimes=sptimes(1:end-4);
    fname=strcat(savedir,'\',sptimes,'_refp',num2str(refp*1000),'_sub.txt');
    dlmwrite(fname,spt2,'precision',8,'delimiter','\n');
end
