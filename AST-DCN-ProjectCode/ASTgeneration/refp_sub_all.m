% Script to get all ASTs or spiketime data in folder and subtract refractory period

%d = uigetdir(pwd, 'Select a folder');
function refp_sub_all(no,savedir)
% d='./';
d = savedir;
% name = strcat('gammaspikes','_',num2str(no),'*','.txt');
name = strcat('gammaspikes','_','*','.txt');
files = dir(fullfile(d, name));%'gammaspikes_num2str(no)*.txt'));


for filenum=1:length(files)
    spiketrains_refp_subt(files(filenum).name,1,0.003,savedir,1); %gammaspikes units = seconds
end