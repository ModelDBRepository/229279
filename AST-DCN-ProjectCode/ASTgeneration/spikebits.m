function [spbits] = spikebits(spk_t,tunit,binsize,fig,color,txt,fname)
%function [spbits] = spikebits(spk_t,tunit,binsize,fig,color,txt,fname)
% bits of spiketrains (ONE'S AND ZERO'S FOR RASTER PLOT)
% Input arguments 
%   spk_t -> file or vector containing the spike times in whatever units (i.e. 0.1 ms for Heck data)
%   tunit -> multiplier to convert your data to seconds (i.e. 0.0001 for Heck data)
%   binsize -> desired bin size (in seconds) of output (i.e. 0.001 for ms)
%   fig -> if 1, plot
%   color -> plot color
%   txt -> if 1 write to text file
%   fname -> optional output filename
%
%   Output - time unit of output is specified by binsize 


%% Load data
if(isstr(spk_t)==0)
    spktimes = spk_t;
else
    spktimes = load(spk_t);
end

%% Converting spike times to 1s and 0s
% Convert to desired units
spktimes1 = ceil((spktimes*tunit*(1/binsize))); 

% Put data into matrix of 1s and 0s - 1 means spike time
% Index is time in desired units
spbits = sparse(1,spktimes1,1); 
spbits = full(spbits);

% Clean up in case of large binsize
spbits(spbits>1)=1;

%% Setting up time vector for plotting

% Duration of spiketimes file in seconds
duration=length(spbits)*binsize;

% Time vector using bin size
t = binsize:binsize:duration;    
 
%% Plot and save
if(fig==1)
    plot(t,spbits',color,'LineWidth',2)
end

if(txt==1) 
    if(nargin==6)
        outfile=strcat('bits_',spk_t);
    else
        outfile=strcat('bits_',fname,'.txt');
    end
    dlmwrite(outfile,spbits,'delimiter','\n');
end
