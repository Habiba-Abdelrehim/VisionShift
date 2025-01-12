function [y] = k(x)
% Here we compute the chosen kernel's profile.
% If we chose the Epanechnikov kernel K(x)=c*(1-|x|^2) with c some
% constant, then its profile is k(x)=1-x if 0<=x<=1 and 0 else.
    if x >= 0 && x <= 1
        y = 1 - x;
    else
        y = 0;
    end
end
