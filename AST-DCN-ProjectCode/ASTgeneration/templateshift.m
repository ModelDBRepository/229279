function [shifted,i] = templateshift(fname,shift)
% Templateshift(fname)
% Function to create a single shifted-in-time signal
% fname -> filename or matrix with signal to be shifted (single column or row)
% shift -> optional predetermined shift length. If not specified, uses
% random number 

%Init
if (ischar(fname))
    r=load(fname);
else
    r=fname;
end

len=length(r);
if nargin >1
    i=shift;
else
    i=round(rand(1)*len);
end

%shift template
if isrow(r)
    shifted=horzcat(r((i+1):len),r(1:(i)));
else
    shifted=vertcat(r((i+1):len),r(1:(i)));
end

end

