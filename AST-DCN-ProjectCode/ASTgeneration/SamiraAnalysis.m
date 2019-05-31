%%------------------------------------------------
% Main script for calling data analysis scripts
%Updated on 6/2/2017
%%------------------------------------------------
   clear; clc; close all
%% Global Parameters Init

refp=0;
if refp
    refp_sub_all
end

%clear all
% time units for bio data
bio_t=0.0001; % conversion factor for input bio data - into seconds
desired_t=0.001; % desired units (aka conversion factor for new data to seconds)

%%  Compare bio / AST PSTH

%init
win = 450; %desired window size in samples/steps
order = 30; %order of median filter for smoothing of PSTH

%Get behavioral modulation PSTH
behpsth=load('PSTH_flat.txt');%load('PSTH_movavgorder_30_cellnum_43.txt'); %load('PSTH_flat.txt');%

%Get bio PSTHs
nums= {30};
len=length(nums);
% [bioPSTH,biomeanPSTH,biostdPSTH]=getPSTHs(0,nums,win,order,bio_t,desired_t);

%Get AST PSTHs
ASTnums=1:1; %1:100;
ASTlen=length(ASTnums);
[ASTPSTH,ASTmeanPSTH,ASTstdPSTH]=getPSTHs(1,nums,win,order,bio_t,desired_t,ASTnums);

%Plot loop
for i=1:len
    for j=1:ASTlen
%         figure(j+(100*i))
figure
        plot(behpsth,'g')
        hold on
%         plot(bioPSTH{i,1},'c')
        plot(ASTPSTH{i,j},'m')
        legend('BehPSTH','BioPSTH','AstPSTH')%Added by Samira
%         [hl, hp] = boundedline(1:win, biomeanPSTH{i,1}, biostdPSTH{i,1}, 'k',  1:win, ASTmeanPSTH{i,j}, ASTstdPSTH{i,j}, 'r', 'alpha');
    end
end

%% Analysis loop
bioStats=zeros(len,4); %cell,mean_fr,lv,cv
astStats_sweep=zeros(len,4); %cellnum,mean_fr,lv,cv

for i=1:len
    %Init
    cellnum=nums{i};
    astStats=zeros(ASTlen,4); %cellnum,mean_fr,lv,cv
    
    %Bio
    fname=data_spt(cellnum);
    biodat=load(strcat(fname,'_refp3.txt')).*0.0001; %convert to seconds
    bioStats(i,1)=cellnum;
    
    %% Get bio stats
    [N,cv,localvar,mean_fr]=spiketrainstat(biodat,1);
    bioStats(i,2:4)=[mean_fr,localvar,cv];
    
    %% Get bio rate templates
    BIOfixedwinRate = fixedGauss_FRest(biodat,1,0,'.k');
    
    for j=1:ASTlen
        %% Load Data
        ASTnum=ASTnums(j);
        astStats(j,1)=ASTnum;
        
        %grab ASTs: real time or compressed time
        if refp
            fname=strcat('gammaspikes_',num2str(cellnum),'_',num2str(ASTnum),'_refp3_sub.txt');
        else
            fname=strcat('gammaspikes_',num2str(cellnum),'_',num2str(ASTnum),'.txt');
        end
        AST=load(fname);
        
        %% Get AST stats
        [~,cv,localvar,mean_fr]=spiketrainstat(AST,1);
        astStats(j,2:4)=[mean_fr,localvar,cv];
        
        %% Compare bio / AST rate templates
        ASTfixedwinRate = fixedGauss_FRest(AST,1,0,'.r');
        figure((1000*cellnum)+j)
        subplot(3,1,1)
        set(gca,'Fontsize',14)
        BIOadapwinRate = adaptGauss_FRest(biodat,BIOfixedwinRate,1,1.5,1,'.k');
        hold on
        ASTadapwinRate = adaptGauss_FRest(AST,ASTfixedwinRate,1,1.5,1,'.r');
        legend('BIOadapwinRate','ASTadapwinRate')
        hold on
        time_events = tick_marks(cellnum,bio_t,desired_t);
        events = zeros(length(time_events),2);
        events(:,1) = time_events;
        plot(events(:,1),events(:,2),'b^')
        

        %% Compare bio / AST ISI histogram
        bins=(0:2:101); 
        figure
        subplot(3,1,2)
        set(gca,'Fontsize',14)
        
        bioISI=diff(biodat);
        [n,x]=hist(bioISI*1000,bins);
        bar(x,n/trapz(n),'k');
        hold on
        ASTISI=diff(AST);
        [n,x]=hist(ASTISI*1000,bins);
       bar(x,n/trapz(n),'r');
        
        xlabel('ISI (ms)','FontSize', 20)
        ylabel('ISI density','FontSize', 20)
        %% Compare power spectra
        subplot(3,1,3)

        set(gca,'Fontsize',14)
        ASTbits=spikebits(AST,1,0.001,0,'b',0)';
        biobits=spikebits(biodat,1,0.001,0,'b',0)';
        plot_pow_spec(biobits,'binned',desired_t,'k')
        hold on
        plot_pow_spec(ASTbits,'continues',desired_t,'r')
%         %% Plot coherence
%         figure((1000*cellnum)+(j*10))
%         subplot(2,1,1)
%         plot_coherence(biobits,ASTbits,desired_t,'notchronux','k')
        
%         %% Plot cross correlation 
%         subplot(2,1,2)
%         plot_xcorr(biobits,ASTbits,desired_t,1,'k')       
        %Added by Samira: Compare slow and fast rate template
        figure(cellnum)
        subplot(2,1,1)
        set(gca,'Fontsize',14)
         [~,~,~,~] = splitsignal_adjust(BIOfixedwinRate,BIOadapwinRate,1,1,5,'k');
         hold on
         [~,~,~,~] = splitsignal_adjust(ASTfixedwinRate,ASTadapwinRate,1,1,5,'r');
         legend('Bio','AST')
           hold on
          plot(events(:,1),events(:,2),'b^')
          subplot(2,1,2)
        set(gca,'Fontsize',14)
         [~,~,~,~] = splitsignal_adjust(BIOfixedwinRate,BIOadapwinRate,1,1,6,'k');
         hold on
         [~,~,~,~] = splitsignal_adjust(ASTfixedwinRate,ASTadapwinRate,1,1,6,'r');
         hold on
          plot(events(:,1),events(:,2),'b^')

    end
    astStats_sweep(i,:)=astStats(1,:);
%     fname=strcat('ASTstats_cellnum_',num2str(cellnum),'.txt');
%     save(fname,'astStats','-ascii');
end

fname=strcat('BIOstats_refp_sub.txt');
save(fname,'bioStats','-ascii')

%% Compare actual AST population stats to expected AST population stats
bio=load('BIOstats_with_refp.txt');
bio_refpsub=load('BIOstats_refp_sub.txt');
expected=load('astno_rate_lv_cvsl_cvft_psth.txt');%load('aststats_cvsweep.txt');%

% mean(astStats(:,2:4))
% std(astStats(:,2:4))
% 
% mean(bio(:,2:4))
% std(bio(:,2:4))
% 
% mean(expected(:,2:5))
% std(expected(:,2:5))
% 
% Plot expected LV vs actual AST LV (AST LV should be 'compressed time' for best
% comparison)
figure(5)
plot(bioStats(:,3), astStats_sweep(:,3), '*')
hold on
plot(0:1,0:1,'g') %plot a line to show linearity of AST LV and expected LV
xlabel('Expected LV (compressed time)')
ylabel('AST LV (compressed time)')

% quantifying differences (added by Samira)
differennce = zeros(len,4); %creating the difference matrix
differennce(:,1) = bioStats(:,1); % put cell numbeis in the first column
differennce(:,2:4) = bioStats(:,2:4)-astStats_sweep(:,2:4);
differennce = abs(differennce);
norm_diff = zeros(len,4);%creating the norm_diff matrix
norm_diff(:,1) = differennce(:,1);
for i=2:4 % loop for dividing abs difference FR,LV, and CV between bio and AST by means of differences 
    norm_diff(:,i) = differennce(:,i)/mean(differennce(:,i));
end
    
