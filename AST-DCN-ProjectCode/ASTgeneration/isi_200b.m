function  isi_200b( file1,tunit,binw,color )
%isi_200b( file1,tunit,binw )
% e.g. isi_200b('gammaspikes_2.txt',0.0001,10, 'r')
%   file1 contains single column of event times in asci format
%   tunit denotes the unit of time in file1 with respect to seconds, i.e.
%      for a 10 KHz unit (or 0.1 ms tick) one specifies '0.0001'
%   binw denotes width of histogram bins in ms - 200 bins are used
%   color denotes color of ISI plot.  note that plot is made to current
%   figure
%  Selva

if (ischar(file1))
    spt1=load(file1);
else
    spt1=file1;
end

spt_sec=spt1*tunit;
spt1=spt1*tunit*1000; %change unit ms
dur=spt_sec(end);
no_isis=length(spt1);
isi1=diff(spt1);
mean_isi=mean(isi1);
sort_isi=sort(isi1);
sort_isi(end-5:end);
max_isi=max(isi1);

maxx=binw*200;
x=0:binw:maxx;
hist2=hist(isi1,x);
hist2_mean_norm=hist2/length(spt1);
set(gca,'Fontsize',14)
plot(x,hist2_mean_norm, 'color', color, 'marker','*');
xlabel('ms','FontSize', 15)
ylabel('normalized bin count','FontSize', 15)