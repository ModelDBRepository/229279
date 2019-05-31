function [C,lags] = plot_xcorr(fdata1,fdata2,tunit,maxti,color)
% Wrapper for xcorr 
% Plots cross correlation 
% fdata1, fdata2, input of data vectors
% tunit: time unit of data = 1 / sampling rate, e.g. 0.001 for one data
% point per ms
% maxti: maximal +- lag time around zero

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

% Pad smaller dataset to match lengths
len1 = length(data1);
len2 = length(data2);
diff = abs(len1-len2);
if len1<len2
    data1 = [data1;zeros(diff,1)];
else 
    data2 = [data2;zeros(diff,1)];
end

% Get cross correlation 
[C,lags]=xcorr(data1-mean(data1),data2-mean(data2),maxti/tunit,'coeff');
%[C,lags]=xcorr(data1,data2,'coeff');

% Plot 
if nargin > 4
    plot(lags*tunit,C,color)
    xlabel('Lag (s)','FontSize', 15)
    ylabel('Cross correlation','FontSize', 15)
end

end