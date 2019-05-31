% Script to get statistics and distributions from biological data
% Saves to workspace

%% Init for loop
nums={27,28,29,30,31,32,34,37,42,43,44,45,46,47,48,49,51,52,82,83,86};
len=length(nums);
bioStats=zeros(len,7); %cellnum,mean_fr,lv-realtime,cv,cv_s,cv_f,lv-refp

%% Load data and grab stats 
for i=1:len;
    %% Init 
    cellnum=nums{i};
    
    %% Load bio data (real time)
    % example bio spike times for initial rate estimate 
    fname=data_spt(cellnum);
    biodat=load(strcat(fname,'_refp3.txt')).*0.0001; %convert to seconds

    %% Get bio stats
    bioStats(i,1)=cellnum;   
    [~,cv,localvar,mean_fr]=spiketrainstat(biodat,1);
    bioStats(i,2:4)=[mean_fr,localvar,cv];
  
    %% Get rate template from bio data 
    
    % Get fixed Gaussian estimate
    %figure(1)
    fixedwinRate = fixedGauss_FRest(biodat,1,0,'.b'); 
    
    % Get adaptive Gaussian estimate
    %figure(2)
    adapwinRate = adaptGauss_FRest(biodat,fixedwinRate,1,4,0,'.r');
    
    %measure CV for adjusted rate template (split by frequency)
    [~,~, bioStats(i,5), bioStats(i,6)] = splitsignal_adjust(fixedwinRate,adapwinRate,1,1,0);
    
    %% Load bio data (compressed time) for LV estimate
    biodat=load(strcat(fname,'_refp3_sub.txt')).*0.0001; %convert to seconds
    [~,~,localvar,~]=spiketrainstat(biodat,1);
    bioStats(i,7)=localvar;
    
end

%% FR
figure
FRpdf=fitdist(bioStats(:,2),'lognormal');
x = 1:500;
y = pdf(FRpdf,x);
hist(bioStats(:,2))
hold on
plot(x,y*500,'r*');

%% LV (compressed time)
figure
LVpdf=fitdist(bioStats(:,7),'lognormal');
x = 0:0.01:2;
y = pdf(LVpdf,x);
hist(bioStats(:,7))
hold on
plot(x,y*2,'r*');

%% CV - all
figure
CVpdf=fitdist(bioStats(:,4),'lognormal');
x = 0:.01:2;
y = pdf(CVpdf,x);
hist(bioStats(:,4))
hold on
plot(x,y*3,'r*');

%% CV - slow frequencies
figure
CVSpdf=fitdist(bioStats(:,5),'lognormal');
x = 0:.005:1;
y = pdf(CVSpdf,x);
hist(bioStats(:,5))
hold on
plot(x,y,'r*');

%% CV - fast frequencies
figure
CVFpdf=fitdist(bioStats(:,6),'lognormal');
x = 0:.005:1;
y = pdf(CVFpdf,x);
hist(bioStats(:,6))
hold on
plot(x,y,'r*');
