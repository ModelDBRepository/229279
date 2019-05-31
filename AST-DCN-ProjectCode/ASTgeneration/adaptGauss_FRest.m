function [ bp_tr ] = adaptGauss_FRest(fname,estrate,delta,filter,varargin)
% Estimating precise fluctuations in firing rate using gaussians convolved with
% spike times, where each gaussian's standard deviation (sigma) is determined by
% a rough estimate in firing rate at that time (adaptive-width Gaussians)
%
% function [ z ] = FR_gaussian_paulin(fname,estrate,lowcutoff,varargin)
% fname - Spike times. Can pass data directly (vector) or a filename
% estrate - estimated firing rate (likely output from fixed gaussian
% estimation). Units (time between estimations) must be milliseconds. 
% delta - Unit of spike times in fname (multiplier to seconds)
% filter - Smoothing parameter for lower frequencies. Recommended @ 4
% 
% Optional output-related arguments via varargin:
% varargin{1} plot_fig - '1' - actual firing rate, '2' - gaussian curve, '3' - normalized firing rate, '4' - mean subtracted
% varargin{2} color - for ploting
% varargin{3} write - '1' to output both rate and time (unit: milliseconds); '2' to output only rate
% varargin{4} out_fname - Output filename; if not given uses inp_fname 
% varargin{5} stat - toggle for output statistics
% varargin{6} fname -  A tag for stat output when FR estimated for many cases- could be character or numeric

% Output 1- time in seconds 2- estimated firing rate in Hz


%% Rename/load data 
if(ischar(fname)==0)
    spts=ceil(fname*delta*1000); % In units of ms b/c 
else
    spts=ceil(load(fname)*delta*1000);
end

if(ischar(estrate)==0)
    fixGfr=estrate;
else
    fixGfr=load(estrate);
end

%% Init Gaussian kernel and loop vars
gtime_sec = -0.999:0.001:1; % width of kernel, 2 seconds total, 1ms step, units=seconds
len=floor(length(gtime_sec)/2);
z = zeros(1,length(fixGfr(:,1))); 

instFR=[0; 1./((diff(spts))*0.001); 0]; % instantaneous firing rate in Hz

% figure(1)
% hold on

%% Convolve spikes with Gaussian kernel
for i=1:length(spts);
    ind=spts(i);
    
    % Calculate sigma - see Paulin 1995 for Sigma Vs FR relation.
    sigma = 1/(sqrt(2*pi)*(fixGfr(ind,2)/filter)); 
    % Create gaussian 
    gauss = normpdf(gtime_sec,0,sigma); 

    % Check edge effects, and add in the current gauss/spike
    if ind-len <= 0
        z(1:ind+len) = z(1:ind+len)+gauss(abs(ind-len)+1:end);
    elseif ind+len-1 >= length(z)
        z(ind-len:end) = z(ind-len:end)+gauss(1:(end-abs(ind+len-1-length(z))));
    else
        z(ind-len:ind+len-1) = z(ind-len:ind+len-1)+gauss;
    end
    
    % For visualizing Gaussians in plot - Warning: Memory hog!
    %plot(z,'k') 
end

%% Output (includes time)
bp_tr = horzcat(fixGfr(:,1),z');

%% Optional 
if ~isempty(varargin)
    %% Plotting data
    if length(varargin)>1
        plot_fig = varargin{1};
        color = varargin{2};
        
        switch plot_fig
            case 1
                set(gca,'Fontsize',14)
                plot(bp_tr(:,1),bp_tr(:,2),color)
                xlabel('Time (s)','FontSize', 15)
                ylabel('Firing rate (Hz)','FontSize', 15)
            case 2
                figure
                gtime_ms = gtime_sec*1000+1000; % conversion to ms units for plotting 
%                 plot(gtime_ms,normalizedgauss,color) 
            case 3
                set(gca,'Fontsize',14)
                plot(0.0001*bp_tr(:,1),bp_tr(:,2)/mean(bp_tr(:,2)),color)
                xlabel('time (s)','FontSize', 15)
                ylabel('Firing rate (Hz)','FontSize', 15)
            case 4
                set(gca,'Fontsize',14)
                plot(0.0001*bp_tr(:,1),bp_tr(:,2)-mean(bp_tr(:,2)),color)
                xlabel('time (s)','FontSize', 15)
                ylabel('Firing rate (Hz)','FontSize', 15)
        end
    end
    
    %%  Saving data
    if length(varargin)>3
        write = varargin{3};
        out_fname = varargin{4};
        
        if(nargin==10)
            fname_rate=strcat('time_gaussfixrate_rate_lowcutoff_',num2str(lowcutoff),'_',out_fname);
        else
            fname_rate=strcat('time_gaussfixrate_rate_lowcutoff_',num2str(lowcutoff),'_',fname);
        end
        dlmwrite(fname_rate,bp_tr,'delimiter','\t','precision',8);
    end
    
    %% Stats output
    if length(varargin)>5
        stat = varargin{5};
        fname = varargin{6};
        
        mean_fr=mean(bp_tr(:,2));
        std_fr=std(bp_tr(:,2));
        cv_fr=std_fr/mean_fr;
        min_fr_fixed_gauss=min(bp_tr(:,2));
        if(stat==1 && ischar(fname))
            output=fopen('FR_gaussfixrate_stat.txt','a');
            fprintf(output,'%s\t%.3f\t%.3f\t%.3f\t%.3f\n',fname,mean_fr,min_fr_fixed_gauss,std_fr,cv_fr);
        elseif(stat==1 && isnumeric(fname))
            output=fopen('FR_gaussfixrate_stat.txt','a');
            fprintf(output,'%f\t%.3f\t%.3f\t%.3f\t%.3f\n',fname,mean_fr,min_fr_fixed_gauss,std_fr,cv_fr);
        end
        fclose all;
    end
end

