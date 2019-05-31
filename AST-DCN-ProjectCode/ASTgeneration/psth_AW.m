function [rawpsth, smoothpsth_meanone, trialmatrix]= psth_AW(stimindex,spikebits,ps_interval,order,tunit,plotflag,out_fname)
% Function to create peristimulus time histogram and smoothed function of
% overall response to stimulus 
%
% stim - indices for location of stimulation events (sample number)
% spikebits - 1s and 0s to indicate spikes (index corresponds to timestep/sample number)
% ps_interval - peristimulus interval to examine (centered on stimulus)
%               units in sample number. MUST be an even number of samples.
% order - order of median filter for smoothing of PSTH
% tunit - multiplier to convert sample number to seconds
% plotflag - 1 to plot. Optional.
% out_fname - output filename. filtered, normalized, mean of 1, units in tunit

% OUTPUT
% rawpsth - 
% smoothpsth - 
% trialmatrix - 

%% Make PSTH
% Split data into peri-stimulus chunks - maybe overlapping
% (first must check for out-of-bounds errors for edge of matrix)
if stimindex(1)-(ps_interval/2)>=0 && stimindex(end)+(ps_interval/2)<=length(spikebits)
    trialmatrix = spikebits(bsxfun(@plus, (0:ps_interval-1), stimindex-ps_interval/2));
else
    startindex=1;
    endindex=+1;
    while stimindex(startindex)-(ps_interval/2)<=0
        startindex=startindex+1;
    end
    while stimindex(end-endindex)+(ps_interval/2)>=length(spikebits)
        endindex=endindex+1;
    end
    trialmatrix = spikebits(bsxfun(@plus, (0:ps_interval-1), stimindex(startindex:end-endindex)-ps_interval/2));
    %'Warning: some indicies not used because window size too large'
end

% Get trial matrix size - useful for calculations/plotting
[numtrials, numsamples]=size(trialmatrix);

% Calculate mean firing rate for each peristimulus interval
meanFR=(sum(trialmatrix,2)/(numsamples*tunit));

% Calculate PSTH
rawpsth=(sum(trialmatrix,1)/numtrials)/tunit; 

% Smooth PSTH with median filter
%smoothpsth=medfilt1(rawpsth,order);
rawpsth_meanone = [ones(1,50) rawpsth/mean(rawpsth) ones(1,50)];
smoothpsth_meanone=smooth(rawpsth_meanone,order);
smoothpsth_meanone=smoothpsth_meanone(51:end-50);
smoothpsth = smoothpsth_meanone*mean(rawpsth);


%% Plotting 
if nargin > 5 && plotflag==1
    % Plot mean FR
    subplot(1,3,1);
    y=1:numtrials;
    plot(meanFR,y,'*');
    hold on;
    plot(meanFR,y,'r');
    xlabel('Mean Firing Rate (Hz) per cycle','FontSize', 14);
    ylabel('Respiratory Cycle #','FontSize', 14);
    
    % Plot PS raster plot
    subplot(1,3,2);
    [i,j]=find(trialmatrix); %get indicies for 1s
    plot((j-ps_interval/2-1)*tunit,i+1.1,'b*'); %j-1 b/c bsxfun puts index right of center for even windows
    xlabel('Time (S)','FontSize', 14);
    ylabel('Respiratory Cycle #','FontSize', 14);
    
    % Plot PSTH
    subplot(1,3,3);
    x=(-ps_interval/2):1:(ps_interval/2-1);
    x=x*tunit;
    plot(x,rawpsth);
    hold on;
    plot(x,smoothpsth,'r');
    xlabel('Time (S)','FontSize', 14);
    ylabel('PST Firing Rate','FontSize', 14);
end

%% Saving
if nargin > 6
    psth_fname=strcat(out_fname,'.txt');
    dlmwrite(psth_fname,smoothpsth_meanone,'delimiter','\n');
end

end
