 bio_t=0.0001; % conversion factor for input bio data - into seconds
desired_t=0.001; % desired units of ASTs (aka conversion factor for AST spiketimes to seconds)
win = 450;
order = 30;
% refractory period in seconds
refper = 0.003; 

% Which algorithm to use? 1:Selva (make sure filter=4) 2:UngammaForwardLooking (Filter=1) 3:GammaForwardLooking (filter=4)
algorithmflag=2;
% Smoothing of adaptive Gaussian rate estimate
filter = 1;
% portion of final signal based on shifted signal 
shiftfraction=0;%0.3; 

% plotting? y/n 1/0
plotflag = 0; 
% Get fixed Gaussian estimate
 ASTfixedwinRate = fixedGauss_FRest(VarName1,1,0,'.r');
     ASTadapwinRate = adaptGauss_FRest(VarName1,ASTfixedwinRate,1,1.5,1,'.r');