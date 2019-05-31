function [ rate_ast_input_l ] = reghist(data_frcv,data_lv,minx,bin,maxx,rt_col, input_l,fname_append)
%RATEHIST
%reghist('FR_gaussian_sigma_2_stat.txt','lv_min_max_frcvsort.txt',0.07,0.1350,0.475,4, 50);
% reghist('FR_diff_fluc_gentemp_48_scaled_stat_fast_slow_cutoff_5.txt','lv_min_max_frcvsort.txt',0.14,0.07,0.35,9, 50)
%   

data=load(data_frcv); % FR_gaussian_sigma_2_stat.txt
data_lv=load(data_lv); % lv_min_max_frcvsort.txt
x=minx+(bin/2):bin:maxx; %0.7:0.3:1.6
y=data(:,rt_col);

ratehist=hist(y,x);
x1=x-(bin/2);
x2=x+(bin/2);
probperbin=ratehist/sum(ratehist);
tot_ct_nord=(probperbin*input_l);
tot_ct=round(probperbin*input_l);

ratehist_col=[ratehist;ratehist/sum(ratehist);x1;x;x2;tot_ct_nord;tot_ct]';

j=1;
p=1;
q=1;
i=1;
while i<=input_l
    while(j<=tot_ct(p) && i<=input_l)
        rate_ast(q)=(rand*bin)+ratehist_col(p,3);
        lv_ast(q)=(rand*data_lv(p,2))+data_lv(p,1);
        x=lv_ast(q);
        y(q) = (3-x)/(2*x); % k (y) from lv (x) ?
        j=j+1;
        q=q+1;
        i=i+1;
    end
    p=p+1;
    j=1;
end
mean_reg_ast=mean(rate_ast);
rperm=randperm(input_l);
rate_ast_input_l=horzcat(rperm',rate_ast',lv_ast',y);
dlmwrite(strcat(fname_append,'_',num2str(input_l),'_hist.txt'),ratehist_col,'delimiter','\t');
% dlmwrite(strcat(fname_append,'_',num2str(input_l),'_ast.txt'),rate_ast_input_l,'delimiter','\t');