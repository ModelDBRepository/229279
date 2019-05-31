function [trateout,trslow_mn1, cv_s,cv_f] = splitsignal_adjust(fslow_fixedgauss,fmix_flexgauss,gainsl,gainfa,varargin)
% BETACONV 
% To scale the fluctuations for creating artificial spike trains.
% 
% fslow_fixedgauss - slow FR fluctuation - fixed method;
% fmix_flexgauss - FR fluctuation - Adaptive gaussian window method;
% gainsl - For scaling the slow fluctuation
% gainfa - For scaling the fast fluctuation
% lowcutoff - A lower bound value for rate estimation, default 0
% shiftfraction - portion of final signal based on shifted signal 
%
% Optional output-related arguments via varargin:
% varargin{1} plot_fig - '1' - actual firing rate, '2' - gaussian curve,
% '3' - normalized firing rate, '4' - mean subtracted, %added by Samira:
% '5' slow '6' fast
% varargin{2} color - for ploting
% varargin{3} write - '1' to output normalized firing rate and time 
% varargin{4} stat - toggle for output statistics
% varargin{5} fname_stat - A tag for stat output when FR estimated for many cases- could be character or numeric
%
% Return variables 
% trateout - two column, first column time, second column scaled rate
%           estimate with a mean of one
% trslow_mn1 - two column, first col time, second col scaled rate est (low
%           frequencies only) with mean of one

%% Import data
if (ischar(fslow_fixedgauss))
    trslow=load(fslow_fixedgauss);
else
    trslow=fslow_fixedgauss;
end

if (ischar(fmix_flexgauss))
    trmix=load(fmix_flexgauss);
else
    trmix=fmix_flexgauss;
end

% Check that length of two gaussian rate functions match
trslow=trslow(1:length(trmix),:);

% Init input arg
if nargin<5
    plot_flag=0;
    color='.b';
    write_flag=0;
    stat=0;
end

%% Rate function manipulations 
%scale, split into high/low frequencies, gainmodulations, etc

%scale, center at mean = 1
mean_fr=mean(trmix(:,2)); 
rslow_mn1=trslow(:,2)/mean_fr; % Slow frequency component
rfast_mn1=trmix(:,2)./trslow(:,2); % Fast frequency component

% Gain 
rfast_mn1= (1+ (gainfa* (rfast_mn1-1)));
rslow_mn1= (1+ (gainsl* (rslow_mn1-1)));

% Recombine for gain adj all freq rate estimate at mean 1
newrate=rslow_mn1.*rfast_mn1; % basically trmix./mean_fr + gain modulation 

% Add time column for final mixed frequency rate output
trateout=horzcat(trslow(:,1),newrate); 
% Add time column for slow rate output
trslow_mn1=horzcat(trslow(:,1),rslow_mn1(:,1));



%hold on
%plot(trslow(:,1),mean_fr*newrate,'k')

%% Output calculations
%CV 
cv_s=std(rslow_mn1)/mean(rslow_mn1);
cv_f=std(rfast_mn1)/mean(rfast_mn1);

%% Plotting / Saving
if ~isempty(varargin)

    if(varargin{1}==1)
%         plot(trslow(:,1),newrate,varargin{2})
        end
    if(varargin{1}==2)
        subplot(1,2,1)
        plot(trslow(:,1),mean_fr*newrate,'r')
        hold on
        plot(trslow(:,1),mean_fr*rslow_mn1,'k')
        subplot(1,2,2)
        hold on
        plot(trslow(:,1),mean_fr*rfast_mn1,'b')
    end
    if(varargin{1}==3)
        px1=polyfit(rslow_mn1,newrate,1);
        px2=polyfit(rslow_mn1,rfast_mn1,1);
        leg1=strcat(num2str(px1(1)),'*x+(',num2str(px1(2)),')');
        leg2=strcat(num2str(px2(1)),'*x+(',num2str(px2(2)),')');
        subplot(2,1,1)
        plot(rslow_mn1,newrate,'r.')
        hold on
        plot(rslow_mn1,px1(1)*(rslow_mn1)+px1(2),'b')
        legend(leg1)
        title('rslow mn-newrtscale')
        subplot(2,1,2)
        plot(rslow_mn1,rfast_mn1,'r.')
        hold on
        plot(rslow_mn1,px2(1)*(rslow_mn1)+px2(2),'b')
        title('rslow mn-rfast mn')
        legend(leg2)
    end
    % this part was added by Samira
    if(varargin{1}==5)
        plot(trslow(:,1),mean_fr*rslow_mn1,varargin{2})
        xlabel('Time(s)')
        ylabel('Firing rate(Hz)')
    end
        if(varargin{1}==6)
        plot(trslow(:,1),mean_fr*rfast_mn1,varargin{2})
        xlabel('Time(s)')
        ylabel('Firing rate(Hz)')
        end%%%%
      
    if length(varargin)>2
        if(varargin{3}==1)
            fname=strcat('rateconv_gain_',num2str(gainsl),'_',num2str(gainfa),'.txt');
            dlmwrite(fname,trateout,'delimiter','\t','precision',8);
        end
    end
    
    if length(varargin)>3
        if varargin{4}==1
            min_fr=min(mean_fr * newrate);
            mean_newrtscale=mean(newrate);
            mean_fr_newrtscale=mean(mean_fr*newrate);
            min_newrtscale=min(newrate);
            
            mean_rslow_gain=mean(rslow_mn1);
            mean_rfast_gain=mean(rfast_mn1);
            std_rslow_gain=std(rslow_mn1);
            std_rfast_gain=std(rfast_mn1);
            cv_rslow_gain=std(rslow_mn1)/mean_rslow_gain; %CV for mean 1 data
            cv_rfast_gain=std(rfast_mn1)/mean_rfast_gain;
            
            if(ischar(varargin{5}))
                output=fopen(strcat('FR_diff_fluc_stat_fast_slow','.txt'),'a');
                fprintf(output,'%s\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n',fname_stat,min_fr,mean_fr_newrtscale,mean_newrtscale,min_newrtscale,mean_rslow_gain,mean_rfast_gain,cv_rslow_gain,cv_rfast_gain);
            elseif(isnumeric(varargin{5}))
                output=fopen(strcat('FR_diff_fluc_stat_fast_slow','.txt'),'a');
                fprintf(output,'%d\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n',fname_stat,min_fr,mean_fr_newrtscale,mean_newrtscale,min_newrtscale,mean_rslow_gain,mean_rfast_gain,cv_rslow_gain,cv_rfast_gain);
            end
        end
    end
end
end
