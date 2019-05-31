function [] = plot_coherence( fdata1,fdata2,tunit,format,color)
% Wrapper for coherencypb and coherencyc from Chronux pacakage 
% Calculates and plots coherence 
% Inputs:
% fdata1, fdata2:  data containing binned spike trains or rate functions
% for coherence analysis
% tunit: time unit (dt) of fdata1 and fdata2, 0.001 for 1 ms, 1 for 1s  note
% that time unit has to be the same for both data arrays.
% format: describes the data presentation of fdata1/2. If they are binned
% point processes, use 'binned'. If the data is continuous, use
% 'continuous'. See chronux manual for details. 

if (ischar(fdata1))
    data1=load(fdata1);
else
    data1=(fdata1);
end

if (ischar(fdata2))
    data2=load(fdata2);
else
    data2=(fdata2);
end

% Truncate larger dataset to match lengths
len1 = length(data1);
len2 = length(data2);
if len1>len2
    data1 = data1(1:len2);
else 
    data2 = data2(1:len1);
end

% 
% % Pad smaller dataset to match lengths
% len1 = length(data1)
% len2 = length(data2)
% diff = abs(len1-len2)
% if len1<len2
%     data1 = [data1;zeros(diff,1)];
% else 
%     data2 = [data2;zeros(diff,1)];
% end
% 
% %subtract mean
% data1 = data1-mean(data1);
% data2 = data2-mean(data2);

% Get coherence 
Fs = 1 /tunit;
if strcmp(format,'binned')
    [C,~,~,~,~,f,~]=coherencypb(data1,data2,struct('tapers', [6,11], 'Fs', Fs, 'fpass', [0,500]));
    %[C,f] = mscohere(data1,data2,[],[],[],Fs);
elseif strcmp(format,'continuous')
    [C,~,~,~,~,f]=coherencyc(data1,data2,struct('tapers', [6,11], 'Fs', Fs, 'fpass', [0,500]));
    %[C,f] = mscohere(data1,data2,[],[],[],Fs);
elseif strcmp(format,'notchronux')
    nfft = 2^10; noverlap = nfft./4;%nfft was changed from 2^12 to 2^10 by Samira 
    [C,f]=mscohere(data1,data2,hanning(nfft),noverlap,nfft,Fs);
end

% Get moving average 
Cmovavg = movingAverage(C,100);

% Plot 
plot(f(1:length(Cmovavg)),Cmovavg,color) 
xlabel('Frequency (Hz)','FontSize', 15)
ylabel('Coherence','FontSize', 15)

end

% Function for moving average on signal x, window size is w
function y = movingAverage(x, w)
   k = ones(1, w) / w;
   y = conv(x, k, 'valid');
end

