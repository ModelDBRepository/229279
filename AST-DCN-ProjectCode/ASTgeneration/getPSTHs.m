function [smooth,meanPSTH,stdPSTH] = getPSTHs(isAST,nums,win,order,bio_t,desired_t,ASTnums)
% Function to get one or several peristimulus time histograms from data
% isAST - 1-yes 0-no (for choosing filename conventions)
% nums - data numbers if bio data (see data_spt.m etc) OR filenames if AST
% win - PSTH window
% order - order of smoothing for PSTH
%% 
numRTs=length(nums);

if nargin > 6
    numASTsPerRT=length(ASTnums);
else
    numASTsPerRT=1;
end

%init for loop
smooth{numRTs,numASTsPerRT} = [];
meanPSTH{numRTs,numASTsPerRT}= [];
stdPSTH{numRTs,numASTsPerRT}= [];

for j=1:numASTsPerRT
    for i=1:numRTs
        %Grab data
        if ~isAST
            cellnum=nums{i};
            fname=data_spt(cellnum);
            sptimes=load(strcat(fname,'_refp3.txt')); %refp3 for fair comparison to AST
            outputfname=strcat('PSTH_movavgorder_',num2str(order),'_cellnum_',num2str(cellnum));
        else
            cellnum=nums{i};
            if nargin > 6
                fname=strcat('gammaspikes_',num2str(cellnum),'_',num2str(ASTnums(j)),'.txt');

            else
                fname=strcat('gammaspikes_',num2str(cellnum),'.txt');
               
            end
            sptimes=load(fname)*10000;
            outputfname=strcat('AST_PSTH_movavgorder_',num2str(order),'_cellnum_',num2str(cellnum));
        end
        
        % bevtfname=data_exp(i);
        bevtfname=data_insp(cellnum);
        bevt=load(bevtfname);
        
        %Convert spiketimes to binned "bits" (1s for spike, 0 for no spike)
        spbits=spikebits(sptimes,bio_t,desired_t,0,'b',0)';
        
        %Convert bio time unit to desired time unit to match time unit of spbits
        bevt=ceil(bevt*(bio_t/desired_t));
        
        %Get PSTH
        [~,smooth{i,j},~]=psth_AW(bevt,spbits,win,order,desired_t,0,outputfname);
        
        %Get mean/average of shifted PSTH for this dataset
        shiftedPSTH=zeros(100,win);
        for x=1:100
            shiftedspbits=templateshift(spbits);
            [~,shiftedPSTH(x,:),~]=psth_AW(bevt,shiftedspbits,win,order,desired_t,0);
        end
        meanPSTH{i,j}=mean(shiftedPSTH,1);
        stdPSTH{i,j}=std(shiftedPSTH,0,1);
    end
end