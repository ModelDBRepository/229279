function [ kappa ] = lv_kappa(lv)
% lv_kappa(lv)
%   converts local variation to kappa (gamma function parameter)
%   see Shinomoto, Miura and Koyama 2005
kappa=(3-lv)/(2*lv);
end

