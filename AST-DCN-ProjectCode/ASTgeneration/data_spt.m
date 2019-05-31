function [ name ] = data_spt( no )
% Pathnames to spiketime data  (PC simple spikes) organized by number 

base= '..\..\NumberedData';

switch no  
    case 27
        spt_name='03012011_mice_628_a_chan1_PC_SS';  
    case 28
        spt_name='03012011_mice_628_b_chan1_PC_SS';
    case 29
        spt_name='03012011_mice_628_c_chan1_PC_SS';
    case 30
        spt_name='03032011_mice_628_chan_1_PC_SS';
    case 31
        spt_name='03042011_mice_628_chan_1_PC_SS';
    case 32
        spt_name='03082011_mice_629_chan_3_PC_SS';
    case 34
        spt_name='03092011_mice_628_chan_1_PC_SS';
    case 37
        spt_name='05252011_mice_630_chan_2_1220_PC_chan_3_575_MF_with_B_W_2_PC_SS';
    case 42
        spt_name='06292011_MICE_428_CHAN_3_806_SU_a_SS';
    case 43
        spt_name='01122012_chan_2_SS';
    case 44
        spt_name='01122012_chan_5_SS';
    case 45
        spt_name='01122012_chan_4_SS';
    case 46
        spt_name='01192011_chan_5_SS';
    case 47
        spt_name='01212011_chan_6_SS'; 
    case 48
        spt_name='01262011_chan_6_SS';
    case 49
        spt_name='09162010_chan_3_SS';
    case 51
        spt_name='03032011_chan_1_SS';
    case 52
        spt_name='01282011_chan_5_SS'; 
    case 82
        spt_name='04252012_mice_637_chan_1_927_SS';
    case 83
        spt_name='04262012_mice_637_chan_1_1110_SS';
    case 86
        spt_name='06142012_mice_638_chan_1_1710_SS';
    case 89
        spt_name='07282011_mice631_chan2_1366_SU_PC_including_CS_SS'; %CS too
end

name = strcat(base,'\',num2str(no),'\',spt_name);

