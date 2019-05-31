function [ bp_tr] = fixedGauss_FRest(sptime_fname,delta,varargin)
% FR_gaussian_paulin 
% Estimating fluctuations in firing rate using fixed gaussian window 
% function [ z ] = FR_gaussian_paulin( inp_fname,delta,rate,lowcutoff,varargin)
% sptime_fname - Can pass data directly or filename. Spiketimes 
% delta - unit of spike times, generally 0.0001?
% lowcutoff - A lower bound value for rate estimation; Used for creating gamma spike trains. Generally zero? 
% 
% Optional output-related arguments via varargin:
% varargin{1} plot_fig - '1' - actual firing rate, '2' - gaussian curve, '3' - normalized firing rate, '4' - mean subtracted
% varargin{2} color - for ploting
% varargin{3} stat - toggle for output statistics
% varargin{4} fname -  A tag for stat output when FR estimated for many cases- could be character or numeric
% varargin{5} write - '1' to output both rate and time (unit: milliseconds); '2' to output only rate
% varargin{6} out_fname - Output filename; if not given uses inp_fname 

% Output 1- time in seconds 2- estimated firing rate in hz

%% Rename/load data 
% if passing in data, it must be in 'bits' format (1s/0s = spike/no spike)
% if passing filename, contents of file can be raw spike times OR bits
if(ischar(sptime_fname)==0)
    sptime=sptime_fname;
else
    sptime=load(sptime_fname);
end
y = spikebits(sptime,delta,0.001,0,'b',0)';

%% Get minimum instantaneous firing rate 
%mininstFR=min(1./((diff(sptime))*delta)); % convert sptimes to sec

%% Create Gaussian kernel
sigma = 1/(sqrt(2*pi)*4);%*mininstFR); % see Paulin 1995 for Sigma Vs FR relation. *4);%
gtime_sec = -0.999:0.001:1; % width of kernel, 2 seconds total, 1ms step, units=seconds
gauss = normpdf(gtime_sec,0,sigma); % create gaussian 

%% Convolve spikes with Gaussian kernel
z = conv(y,gauss); 
z = z((round(length(gauss)/2):length(z)-(round(length(gauss)/2)))); % remove padding  

%% Units adjustment 
%output_time=(round(length(gauss)/2)+1:length(y)-(round(length(gauss)/2)))'*10;%FIX
%this, use delta. 10 used b/c 0.0001 to 0.001
output_time=(1:length(z))'*0.001;
bp_tr = horzcat(output_time,z);

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
                xlabel('time (s)','FontSize', 20)
                ylabel('Firing rate (Hz)','FontSize', 20)
            case 2
                figure
                gtime_ms = gtime_sec*1000+1000; % conversion to ms units for plotting 
%                 plot(gtime_ms,normalizedgauss,color) 
            case 3
                set(gca,'Fontsize',14)
                plot(0.0001*bp_tr(:,1),bp_tr(:,2)/mean(bp_tr(:,2)),color)
                xlabel('time (s)','FontSize', 20)
                ylabel('Firing rate (Hz)','FontSize', 20)
            case 4
                set(gca,'Fontsize',14)
                plot(0.0001*bp_tr(:,1),bp_tr(:,2)-mean(bp_tr(:,2)),color)
                xlabel('time (s)','FontSize', 20)
                ylabel('Firing rate (Hz)','FontSize', 20)
        end
    end
    
    %% Stats output
    if length(varargin)>3
        stat = varargin{3};
        fname = varargin{4};
        
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
    
    %% Saving data
    if length(varargin)>5
        write = varargin{5};
        out_fname = varargin{6};
        
        if(write==1)
            if(nargin==10)
                fname_rate=strcat('time_gaussfixrate_rate_lowcutoff_',num2str(lowcutoff),'_',out_fname);
            else
                fname_rate=strcat('time_gaussfixrate_rate_lowcutoff_',num2str(lowcutoff),'_',inp_fname);
            end
            dlmwrite(fname_rate,bp_tr,'delimiter','\t','precision',8);
        end
        if(write==2)
            if(nargin==10)
                fname_rate=strcat('gaussfixrate_rate_lowcutoff_',num2str(lowcutoff),'_',out_fname);
            else
                fname_rate=strcat('gaussfixrate_rate_lowcutoff_',num2str(lowcutoff),'_',inp_fname);
            end
            dlmwrite(fname_rate,1000*z,'delimiter','\n','precision',8);
        end
    end
end

