function [meanPSTH, stdPSTH] = psthstats(spbits,bevt,win,order,desired_t)

%Get mean/average of shifted PSTH for this dataset
shiftedPSTH=zeros(100,win);
for x=1:100
    shiftedspbits=templateshift(spbits);
    [~,shiftedPSTH(x,:),~]=psth_AW(bevt,shiftedspbits,win,order,desired_t,0);
end
meanPSTH=mean(shiftedPSTH,1);
stdPSTH=3.*std(shiftedPSTH,0,1);