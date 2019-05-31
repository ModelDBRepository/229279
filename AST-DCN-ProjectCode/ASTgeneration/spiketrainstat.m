function [N, cv,localvar,mean_fr]= spiketrainstat(fname,tunit)
% spiketrainstat - descriptive statistics for event times 
% Input: 
% fname - Either the filename or matlab variable that has event times
%         (single column data)
% tunit - unit of event times


%Checking params
if(nargin<=1)
    error('Not enough parameters- fname,delta_t'); 
end

%Spike times switch (file vs var)
if (isstr(fname))
    sptimes=load(fname);
else
    sptimes=fname;
end

%Units: Change spike times to seconds, ISIs in ms
N = size(sptimes);
sptimes=sptimes*tunit;
isi=diff(sptimes)*1000;

%Stats
mean_fr=1000/mean(isi);
cv=std(isi)/mean(isi);

%Calc LV - Defined as:  mean(3*(((isi_n - isi_n+1)^2)/((isi_n + isi_n+1)^2))))
numer = diff(isi).^2;
denom = (isi(1:end-1)+isi(2:end)).^2;
numer(denom<=0)=[]; % 0 in denominator breaks algorithm. Check for this. 
denom(denom<=0)=[];
localvar = mean(3.*(numer./denom));


