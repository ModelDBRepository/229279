function [ rate_ast_input_l ] = ratehist(data_file,minx,bin,maxx,rt_col,input_l)
% RATEHIST
%  ratehist('stat_refp3_ss_noname.txt',32.5,15,167.5,4,50)
%  
% input_l = number of ASTs to be produced? 

% Load data
data=load(data_file);

% Initial hist
x=minx+(bin/2):bin:maxx;
y=data(:,rt_col);
ratehist=hist(y,x);

% Bin edges and probability per bin
x1=x-(bin/2);
x2=x+(bin/2);
probperbin=ratehist/sum(ratehist);

% Make hist with specified total number of events
tot_ct_nord=(probperbin*input_l);
tot_ct=round(probperbin*input_l);

% Compile outputs
ratehist_col=[ratehist;ratehist/sum(ratehist);x1;x;x2;tot_ct_nord;tot_ct]';

% 
j=1;
p=1;
q=1;
i=1;
while i<=sum(tot_ct)
    while(j<=tot_ct(p) && i<=sum(tot_ct))
        rate_ast(q)=(rand*bin)+ratehist_col(p,3);
        j=j+1;
        q=q+1;
        i=i+1;
    end
    p=p+1;
    j=1;
end
rperm=randperm(sum(tot_ct));
rate_ast_input_l=horzcat(rperm',rate_ast');
dlmwrite(strcat('rate_',num2str(sum(tot_ct)),'_hist.txt'),ratehist_col,'delimiter','\t');
