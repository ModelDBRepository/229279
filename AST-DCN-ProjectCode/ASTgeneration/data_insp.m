function [ name ] = data_insp( no )
% Pathnames to breathing data  (inspiration times) organized by number 

base= '..\..\NumberedData';

switch no
    case 27
        resp_fname='03012011_mice_628_a_inspiration';
    case 28
        resp_fname='03012011_mice_628_b_inspiration';
    case 29
        resp_fname='03012011_mice_628_c_inspiration';
    case 30
        resp_fname='03032011_mice_628_inspiration';
    case 31
        resp_fname='03042011_mice_628_inspiration';
    case 32
        resp_fname='03082011_mice_629_inspiration';
    case 34
        resp_fname='03092011_mice_628_inspiration';
    case 37
        resp_fname='05252011_mice_630_chan_2_1220_PC_chan_3_575_MF_with_B_W_inspiration';
    case 42
        resp_fname='06292011_MICE_428_CHAN_2_1328_MF_INHALE';
    case 43
        resp_fname='01122012_chan_2_1428_inhale';
    case 44
        resp_fname='01122012_chan_5_1936_inhale';
    case 45
        resp_fname='01122012_chan_4_1179_inhale';
    case 46
        resp_fname='01192011_chan_5_1935_inhale';
    case 47
        resp_fname='01212011_chan_6_1144_inhale';
    case 48
        resp_fname='01262011_chan_6_710_inhale';
    case 49
        resp_fname='09162010_chan_3_1177_inhale';
    case 51
        resp_fname='03032011_chan_1_1251_inhale';
    case 52
        resp_fname='01282011_chan_5_1653_inhale';
    case 81
        resp_fname='04112012_mice_636_chan_2_2541_DCN_inhale';
    case 82
        resp_fname='04252012_mice_637_chan_2_1980_DCN_inhale';
    case 83
        resp_fname='04262012_mice_637_chan_3_2407_DCN_inhale';
    case 84
        resp_fname='06132012_mice_638_inhale';
    case 85
        resp_fname='06132012_mice_638_chan_2_2897_DCN_inhale';
    case 86
        resp_fname='06142012_mice_638_chan_3_2682_DCN_inhale';
    case 87
        resp_fname='06222011_chan_2_2352_DCN_inhale';
    case 89
        resp_fname='07282011_mice631_chan_3_1978_DCN_inhale';
    case 90
        resp_fname='07282011_mice_631_chan_3_2117_DCN_inhale';
    case 101
        resp_fname='06292011 chan 2 2356 DCN inhale';
end

name = strcat(base,'\',num2str(no),'\',resp_fname,'.txt');


