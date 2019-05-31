function [spiketimes] = singleASTgen(savedir,ASTbehmodfraction,fname_sptime,bevt...
    ,meanbiorate,reg,refper,psth_norm2one,algorithmflag,fileno)
% Function to create an artificial spike train
% 
% Arguments:
%savedir: directory to save ASTs in there.
%ASTbehmodfraction: fraction of ASTs that has beh mod
% fname_sptime - filename or data: two col: 1- time vector in seconds
%               2- firing rate estimate from spiketimes (gain adjusted and normalized to mean=1)
% bevt - behavioral event times (for same recording as fname_sptime)
% meanbiorate - a measured mean firing rate from the biological population (to be applied to mean 1
%            rate estimate, constant)
% reg - regularity parameter (constant) kappa=(3-lv)/(2*lv)
% refper - refractory period (constant) in seconds.
% psth_norm2one - Biological peri-stimulus time histogram (PSTH) normalized and significantly smoothed
% algorithmflag - 1- no forward-looking component 2- ungamma forward-looking 3- gamma and forward-looking
% fileno - Optional save flag. If included, number or string is included in filename,
%           i.e. gammaspikes_fileno.txt

% Returns: spike times in units of 0.1ms

%% Import data
% Event times
if ischar(bevt)==1
    bevt=load(bevt);
end

% Spike times and firing rate estimate
if(ischar(fname_sptime)==0)
    times=fname_sptime(:,1); 
    splitgain_FR=fname_sptime(:,2);
else
    tmrt=load(fname_sptime);
    times=tmrt(:,1);
    splitgain_FR=tmrt(:,2);
end

% Biological peri-stimulus time histogram (PSTH) normalized and significantly smoothed 
if(ischar(psth_norm2one)==0)
        psth=psth_norm2one;     
else
        psth=load(psth_norm2one);
    end


%% Add in behavioral modulation for each behavioral event time 
before=floor(length(psth)/2); %length of chunk of psth before beh event
after=floor(length(psth)/2); %length of chunk of psth after beh event
len = length(splitgain_FR); %length of rate template
center = floor(length(psth)/2); %half length of PSTH

for i=1:length(bevt)-1
    ind=ceil(bevt(i)*1000); %index of current behavioral event
    nextind=ceil(bevt(i+1)*1000); %index of next event
    midpoint = (nextind-ind)/2; %half distance between events
    
    % Check for overlap of psth's between behavioral events
    if midpoint < after
        after=floor(midpoint);
    end
             
    % Check edge effects
    if ind-before <= 0
        before = before + (ind-before)-1;
    elseif ind+after-1 > len
        after = after + (ind+after-len);
    end
    
    % Center PSTH at behavior event time and multiply PSTH with template
    splitgain_FR(ind-before:ind+after-1)=splitgain_FR(ind-before:ind+after-1).*psth(center-before+1:center+after);
    
    % Reset 
    before=floor(length(psth)/2);        
    after=floor(length(psth)/2);
    
    % Check for overlap of psth's between behavioral events for next event
    if midpoint < before 
        before=floor(midpoint);
    end
    
end 

%% Renormalization, adjust mean rate and refractory period 

% Adjust mean rate (Renormalize before because behavioral modulation may change mean of 1)
mean_splitgain_FR=mean(splitgain_FR); 
irate2=(splitgain_FR/mean_splitgain_FR)*meanbiorate;

% Remove refractory period
irate2(irate2>333) = 333; %prevent spike overlap / leap-frogging due to refper subtraction
irate= 1./((1./irate2)-refper); %convert hz to seconds, subtract refper, convert back to hz
irate(irate<2) = 2; % lowcutoff

%% Pull spike times from Gamma distribution to generate AST
% Params for Gamma: rate from rate template (and k from Lv distribution = reg)

lastspt=0; %last spiketime
currt=1; %current time
j=1; %index for ISI vector
times=times(1:length(irate));
isis=zeros(1,length(times));
recalc=0;
%figure(10); hold off; plot(times,irate); hold on;

while(lastspt<times(end))
    
    %Increment time to next ISI time.
    %If the rate template increases dramatically relative to current ISI,
    %re-evaluate ISI
    while(currt<length(irate) && lastspt>=times(currt))
        if algorithmflag==2 && irate2(currt) > ((4/isis(j-1))) && j>1
            %plot([lastspt-isis(j-1) times(currt)],[mr irate(currt)],'k'); hold on;
            lastspt=lastspt-isis(j-1); %rewind ISI count
            isis(j-1)=times(currt) - lastspt + refper; %update currISI (from last ISI end to current time)
            lastspt=lastspt+isis(j-1);
            %plot(lastspt,mr,'g*'); hold on;
            recalc=recalc+1;
            break
        end
        
        if algorithmflag==3 && (irate2(currt)) > ((1/isis(j-1))+(meanbiorate)) && j>1 %((11/isis(j-1)))
            %plot([lastspt-isis(j-1) times(currt)],[mr irate(currt)],'k'); hold on;
            lastspt=lastspt-isis(j-1); %rewind ISI count
            mr=1/(times(currt)-lastspt); %get FR from interval traversed before increase in FR
            
            if mr<2
                mr=2; 
            end
                  
            %recalculate ISI from gamma (with new mr)
            Vrandth = gamrnd(reg,1/reg); 
            currISI = Vrandth*(1/mr);
            isis(j-1)= currISI + refper;
            lastspt=lastspt+isis(j-1);
            
            %plot(times(currt),mr,'r*'); plot([lastspt times(currt)],[mr mr],'r');plot(lastspt,mr,'g*'); hold on;
            
            %reset currt
            while currt>1 && times(currt)> lastspt 
                currt = currt - 1;
            end
            while currt>1 && times(currt)< lastspt && currt<length(irate)
                currt = currt + 1;
            end
                       
            recalc=recalc+1;
            break
        end
           
        currt = currt + 1;
    end
      
    % gamrnd = matlab fn for random arrays from gamma distribution. 
    % Given arguments get a mean firing rate of 1
    Vrandth = gamrnd(reg,1/reg);  
    
    %grab current rate estimate
    mr=irate(currt); 
    
    % adjust mean ISI/rate with current rate 
    currISI = Vrandth*(1/mr);
    
    % Add refractory period back in
    isis(j)= currISI + refper;
    lastspt=lastspt+isis(j);
    %hold on; plot(times(currt),mr,'k*'); plot([lastspt times(currt)],[mr mr],'g')
    j=j+1;
end

if algorithmflag==2 || algorithmflag==3
    recalc
end

spiketimes=cumsum(isis(1:j));

%% Save 
if nargin>6
    if ischar(fileno)==1
        gammafile=strcat('gammaspikes_',fileno,'.txt');
    else
        gammafile=strcat('gammaspikes_',num2str(fileno),'.txt');
    end
    
    dlmwrite(gammafile,spiketimes,'delimiter','\n','precision',8);
    movefile(gammafile,savedir);
end
