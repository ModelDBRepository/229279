function [] = plot_pow_spec(fdata,format,tunit,color)
% Wrapper for mtspectrumpb from Chronux pacakage 
% Plots power spectrum in addition to a sliding window average
% Inputs:
% fdata: data containing binned spike trains or rate functions
% for coherence analysis
% format: describes the data presentation of fdata1/2. If they are binned
% point processes, use 'binned'. If the data is continuous, use
% 'continuous'. See chronux manual for details. 
% tunit: time unit (dt) of fdata1 and fdata2, 0.001 for 1 ms, 1 for 1s  note
% that time unit has to be the same for both data arrays.

if (ischar(fdata))
    data=load(fdata);
else
    data=(fdata);
end

% Remove DC component
data=data-mean(data);
data=detrend(data); %added 
% Get power spectrum 
Fs = 1 /tunit;
% [psd1, S1] = mtspectrumpb(data, struct('tapers', [3,5], 'Fs', Fs, 'fpass', [0,Fs/2]));% added by Samira
% [psd1,S1] = pwelch(data,[],0,[],Fs);% added by Samira
[psd1, S1] = mtspectrumpb(data, struct('tapers', [3,5], 'Fs', Fs, 'fpass', [0,Fs/2]));%added by Samira
% [psd1, S1] = mtspectrumc(data, struct('tapers', [3,5], 'Fs', Fs, 'fpass', [0,Fs/2]));%added by Samira
if strcmp(format,'b')
%     [psd1,S1] = pwelch(data,[],0,[],Fs);
    [psd1, S1] = mtspectrumpb(data, struct('tapers', [3,5], 'Fs', Fs, 'fpass', [0,Fs/2]));
elseif strcmp(format,'c')
%     [psd1,S1] = pwelch(data,[],0,[],Fs);
    [psd1, S1] = mtspectrumc(data, struct('tapers', [3,5], 'Fs', Fs, 'fpass', [0,Fs/2]));
end

% Get log of power spectrum
% logpow=10*log10(psd1);
logpow=log10(psd1);%added by Samira
% Get moving average of power spectrum 
powmovavg = movingAverage(logpow,100);

% % Plot mV^2 power spectrum
% subplot(1,2,1); hold on;
% plot(S1, psd1)%, color) 
% xlabel('Frequency (Hz)','FontSize', 15)
% ylabel('Power','FontSize', 15)
% 
% % Plot dB power spectrum
% subplot(1,2,2);
plot(S1(1:length(powmovavg)),powmovavg,color) 
xlabel('Frequency (Hz)','FontSize', 15)
% ylabel('Power (dB)','FontSize', 15)
 ylabel('Log Power','FontSize', 15)%added by Samira

end

% Function for moving average on signal x, window size is w
function y = movingAverage(x, w)
   k = ones(1, w) / w;
   y = conv(x, k, 'valid');
end
