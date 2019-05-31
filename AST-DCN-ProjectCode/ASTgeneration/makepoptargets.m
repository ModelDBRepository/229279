function [poptargets] = makepoptargets(numASTs, FR, LV, CVS, CVF, behmodfraction)
% Used to generate parameters for artificial spike train populations 
% Output: [ASTidentifier meanFRtarget LVtarget gainsl gainfa psthY/N]
% parameters:
%   if based on biological distributions (randomly drawn from dist) use 'dist'
%   otherwise, provide one number for a constant throughout the population 
%   or two numbers for a range (evenly spaced based on numASTs)
% the exception is behmodfraction which is always a single number (<1) 
% specifiying the fraction of ASTs which will have behavioral modulation and  
% numASTs which is the desired number of parameter sets in the output
% 
% Example input: makepoptargets(50, 80, 0.47, 0.24, 0.17, 0); <- based on "representative" bio data #28
% Example input: makepoptargets(50, 'dist', 'dist', 'dist','dist', 0.3); <- bio based ranges
% Example input: makepoptargets(50, [50 120], 0.47, 0.24, 0.17, 0); <- LV sweep

% Load distributions for LV, CV, Mean rate (based on bio distributions via dfittool or made up) 
load('StatDist-CV-LV-meanFR-PCSS-mixedsource.mat') % .mat file with variables FRpdf, LVpdf, CVpdf, CVSpdf and CVFpdf

% Init
poptargets = zeros(numASTs,6);
poptargets(:,1) = 1:numASTs; % AST identifiers 

% Get params according to input instructions 
poptargets(:,2) = get_targets(numASTs, FR, FRpdf);
poptargets(:,3) = get_targets(numASTs, LV, LVpdf);
poptargets(:,4) = get_targets(numASTs, CVS, CVSpdf);
poptargets(:,5) = get_targets(numASTs, CVF, CVFpdf);

% Behavioral modulation or no behavioral modulation? (one or zero)
psth=zeros(numASTs,1);
getspsth=randperm(numASTs);
psth(getspsth(1:ceil(behmodfraction*numASTs)),1)=1; %which ASTs get a non-flat psth?
poptargets(:,6) = psth;

end 


function [targets] = get_targets(numAST, x, xpdf)

if ischar(x)
    targets = random(xpdf,numAST,1); % random values from biopop
elseif length(x)==1
    targets = x;
else
    range=(x(2)-x(1));
    step=(range/numAST);
    targets = (step:step:range)+x(1);
end

end 
