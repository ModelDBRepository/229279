function [bioStats, astStats] = bioVSast(nums, i, bio_t, ASTnum,savedir, refp )
% Function to compare a biological spike train to a population of AST spike
% trains. 
%
% Input: 
% nums - biological identifiers (cell array) i.e. {27,28,29,30,31,32,34,37,42,43,44,45,46,47,48,49,51,52,82,83,86};
% bio_t - time unit for biological data (0.0001 for old Heck data, 1 for new)
% ASTnums - number of ASTs created per biological spike train
%savedir: directory to save gammaspikes
% refp - have ASTs been prepped for analysis in compressed time? Y(0) N(1) 
%


%% Get refp subtracted ASTs if needed
if refp
    refp_sub_all(i,savedir)
end

%%  Compare bio / AST PSTH

%init
win = 450; %desired window size in samples/steps
order = 30; %order of median filter for smoothing of PSTH
desired_t=0.001; % desired units for PSTH (aka conversion factor for new data to seconds)

%Get behavioral modulation PSTH
behpsth=load('PSTH_flat.txt');%load('PSTH_movavgorder_30_cellnum_43.txt'); %load('PSTH_flat.txt');%

%Get bio PSTHs
len=length(nums);
% [bioPSTH,biomeanPSTH,biostdPSTH]=getPSTHs(0,nums,win,order,bio_t,desired_t);
% 
% %Get AST PSTHs
 ASTnums=1:ASTnum; 
 ASTlen=length(ASTnums);
% [ASTPSTH,ASTmeanPSTH,ASTstdPSTH]=getPSTHs(1,nums,win,order,bio_t,desired_t,ASTnums);
% 
% %Plot loop
% for i=1:len
%     for j=1:ASTlen
%         figure(j+(100*i))
%         plot(behpsth,'g')
%         hold on
%         plot(bioPSTH{i,1},'k')
%         plot(ASTPSTH{i,j},'r')
%         boundedline(1:win, biomeanPSTH{i,1}, biostdPSTH{i,1}, 'k',  1:win, ASTmeanPSTH{i,j}, ASTstdPSTH{i,j}, 'r', 'alpha');
%     end
% end

%% Analysis loop
load('StatDist-CV-LV-meanFR-PCSS-mixedsource.mat','bioStats'); %cellnum,mean_fr,lv-realtime,cv,cv_s,cv_f,lv-refp

for i=1:len
    %Init
    cellnum=nums{i};
    astStats=zeros(ASTlen,7); %cellnum,mean_fr,lv-realtime,cv,cv_s,cv_f,lv-refp
    
    %Bio
    fname=data_spt(cellnum);
    biodat=load(strcat(fname,'_refp3.txt')).*0.0001; %convert to seconds
      
    %% Get bio rate templates
    BIOfixedwinRate = fixedGauss_FRest(biodat,1,0,'.k');
    
    for j=1:ASTlen
        %% Load Data
        ASTnum=ASTnums(j);
        astStats(j,1)=ASTnum;
        
        %grab ASTs: real time and compressed time
        fname=strcat('gammaspikes_',num2str(cellnum),'_',num2str(ASTnum));
 
        AST=load(strcat(savedir,'\',fname,'.txt'));%.*0.0001;
        ASTrefp=load(strcat(savedir,'\',fname,'_refp3_sub.txt'));%.*0.0001;
                      
        %% AST (compressed time) for LV estimate
        [~,~,localvar,~]=spiketrainstat(ASTrefp,1);
        astStats(j,7)=localvar;
        
        %% Get rate template for CV fast/slow estimation / comparison
        
        % Get fixed Gaussian estimate
        %figure(1)
        fixedwinRate = fixedGauss_FRest(AST,1,0,'.b');
        
        % Get adaptive Gaussian estimate
        %figure(2)
        adapwinRate = adaptGauss_FRest(AST,fixedwinRate,1,4,0,'.r');
        
        %measure CV for adjusted rate template (split by frequency)
        [~,~, astStats(j,5), astStats(j,6)] = splitsignal_adjust(fixedwinRate,adapwinRate,1,1,0);
                
        
        %% Get AST stats
        [~,cv,localvar,mean_fr]=spiketrainstat(AST,1);
        astStats(j,2:4)=[mean_fr,localvar,cv];
        
%         %% Compare bio / AST rate templates
%         ASTfixedwinRate = fixedGauss_FRest(AST,1,0,'.r');
%         figure((1000*cellnum)+j)
%         subplot(3,1,1)
%         set(gca,'Fontsize',14)
%         BIOadapwinRate = adaptGauss_FRest(biodat,BIOfixedwinRate,1,1.5,1,'.k');
%         hold on
%         ASTadapwinRate = adaptGauss_FRest(AST,ASTfixedwinRate,1,1.5,1,'.r');
%         
%         %% Compare bio / AST ISI histogram
%         bins=(0:51);        
%         subplot(3,1,2)
%         set(gca,'Fontsize',14)
%         
%         bioISI=diff(biodat);
%         [n,x]=hist(bioISI*1000,bins);
%         plot(x,n/trapz(n),'k');
%         hold on
%         plot(x,n/trapz(n),'k*');
%         
%         ASTISI=diff(AST);
%         [n,x]=hist(ASTISI*1000,bins);
%         plot(x,n/trapz(n),'r');
%         plot(x,n/trapz(n),'r*');
%         
%         xlabel('ISI (ms)','FontSize', 20)
%         ylabel('ISI density','FontSize', 20)
%         
%         %% Compare power spectra
%         subplot(3,1,3)
%         set(gca,'Fontsize',14)
%         ASTbits=spikebits(AST,1,desired_t,0,'b',0)';
%         biobits=spikebits(biodat,1,desired_t,0,'b',0)';
%         plot_pow_spec(biobits,'binned',desired_t,'k')
%         hold on
%         plot_pow_spec(ASTbits,'binned',desired_t,'r')
%         plot_pow_spec(BIOadapwinRate(:,2),'continuous',desired_t,'k.')
%         plot_pow_spec(ASTadapwinRate(:,2),'continuous',desired_t,'r.')
%         
%         %% Plot coherence
%         figure((1000*cellnum)+(j*10))
%         subplot(2,1,1); hold on;
%         plot_coherence(biobits,ASTbits,desired_t,'notchronux','r');%'binned'
%         plot_coherence(BIOadapwinRate(:,2),ASTadapwinRate(:,2),desired_t,'notchronux','b');%'continuous'
%         %plot_coherence(biobits,ASTbits,desired_t,'notchronux','k')
%         
%         %% Plot cross correlation 
%         subplot(2,1,2); hold on;
%         plot_xcorr(biobits,ASTbits,desired_t,1,'r');   
%         plot_xcorr(BIOadapwinRate(:,2),ASTadapwinRate(:,2),desired_t,1,'b');
%               
%         %calc xcorr stats and add to plot
%         [datnmeanC, datnstdC, lags] = xcorrstats(biobits,ASTbits,desired_t,1);
%         boundedline((lags.*desired_t), datnmeanC, datnstdC, 'r', 'alpha');
%         [datnmeanC, datnstdC, lags] = xcorrstats(BIOadapwinRate(:,2),ASTadapwinRate(:,2),desired_t,1);
%         boundedline((lags.*desired_t), datnmeanC, datnstdC, 'b', 'alpha');
    
        
    end
    fname=strcat('ASTstats_cellnum_',num2str(cellnum),'.txt');
    save(fname,'astStats','-ascii');
    
    %% Compare bio stats to AST population stats
    % two hists (bio vs AST) with highlighted data for cell AST is based on
    % cellnum,mean_fr,lv-realtime,cv,cv_s,cv_f,lv-refp
    figure(cellnum)
    
    %FR hists      
    subplot(4,2,1); hold on;
    [n1, xout1] = hist(bioStats(:,2),0:25:200);
%     bar(xout1,n1,'r',); 
    [n2, xout2] = hist(astStats(:,2),0:25:200);
%     B=bar(xout2,n2,'g','grouped');
    B=bar([xout1' xout2'],[(round(ASTnum/21*n1))' n2'],'grouped'); grid; %added by Samira
    barmap=[1 0 0; 0 1 0]; 
    colormap(barmap);
    legend('Bio','AST')
%     ch = get(B,'child');
%     set(ch,'facea',.5)
    xlabel('Firing Rate','FontSize', 12)
    % somehow highlight cellnum / nums{i} / basis for AST - line? 
        
    %LV hists - real time
    subplot(4,2,2); hold on;
    [n1, xout1] = hist(bioStats(:,3),0:0.1:1);
%     bar(xout1,n1,'r'); grid; 
    [n2, xout2] = hist(astStats(:,3),0:0.1:1);
    B=bar([xout1' xout2'],[(round(ASTnum/21*n1))' n2'],'grouped');grid; %added by Samira
%     B=bar(xout2,n2,'g');
%     ch = get(B,'child');
%     set(ch,'facea',.5)
    xlabel('LV - real time','FontSize', 12)
    
    %CV hists - real time
    subplot(4,2,3); hold on;
    [n1, xout1] = hist(bioStats(:,4),0:0.1:2);
%     bar(xout1,n1,'r'); grid; 
    [n2, xout2] = hist(astStats(:,4),0:0.1:2);
    B=bar([xout1' xout2'],[(round(ASTnum/21*n1))' n2'],'grouped');grid; %added by Samira
%     B=bar(xout2,n2,'g');
%     ch = get(B,'child');
%     set(ch,'facea',.5)
    xlabel('CV','FontSize', 12)
    
    %CV hists - slow
    subplot(4,2,4); hold on;
    [n1, xout1] = hist(bioStats(:,5),0:0.05:0.5);
%     bar(xout1,n1,'r'); grid; 
    [n2, xout2] = hist(astStats(:,5),0:0.05:0.5);
    B=bar([xout1' xout2'],[(round(ASTnum/21*n1))' n2'],'grouped');grid; %added by Samira
%     B=bar(xout2,n2,'g');
%     ch = get(B,'child');
%     set(ch,'facea',.5)
    xlabel('CV - slow','FontSize', 12)
    
    %CV hists - fast
    subplot(4,2,5); hold on;
    [n1, xout1] = hist(bioStats(:,6),0:0.05:0.5);
%     bar(xout1,n1,'r'); grid; 
    [n2, xout2] = hist(astStats(:,6),0:0.05:0.5);
    B=bar([xout1' xout2'],[(round(ASTnum/21*n1))' n2'],'grouped');grid; %added by Samira
%     B=bar(xout2,n2,'g');
%     ch = get(B,'child');
%     set(ch,'facea',.5)
    xlabel('CV - fast','FontSize', 12)
    
    %LV hists - compressed time
    subplot(4,2,6); hold on;
    [n1, xout1] = hist(bioStats(:,7),0:0.1:1.5);
%     bar(xout1,n1,'r'); grid; 
    [n2, xout2] = hist(astStats(:,7),0:0.1:1.5);
    B=bar([xout1' xout2'],[(round(ASTnum/21*n1))' n2'],'grouped');grid; %added by Samira
%     B=bar(xout2,n2,'g');
%     ch = get(B,'child');
%     set(ch,'facea',.5)
    xlabel('LV - compressed time','FontSize', 12)
    
    %CV vs LV-compressed
    subplot(4,2,7); hold on;
    plot(bioStats(find(bioStats==cellnum),4),bioStats(find(bioStats==cellnum),7),'k*')
    plot(bioStats(:,4),bioStats(:,7),'r.')
    plot(astStats(:,4),astStats(:,7),'g.')
    xlabel('CV','FontSize', 12)
    ylabel('LV-compressed time','FontSize', 12)
    
    %CV vs LV-real
    subplot(4,2,8); hold on;
    plot(bioStats(find(bioStats==cellnum),4),bioStats(find(bioStats==cellnum),3),'k*')
    plot(bioStats(:,4),bioStats(:,3),'r.')
    plot(astStats(:,4),astStats(:,3),'g.')
    xlabel('CV','FontSize', 12)
    ylabel('LV - real time','FontSize', 12)
    
end
